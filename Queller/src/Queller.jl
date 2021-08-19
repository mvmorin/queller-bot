module Queller

using TextWrap

export load_graphs,
	check_queller_graphs,
	main

################################################################################

not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)
strvec2str(v,sep='\n') = reduce((s,t) -> s*sep*t, v)

################################################################################

include("cli.jl")
include("dice_and_strategy.jl")
include("graph.jl")
include("crawler.jl")

################################################################################

const PKG_DIR = abspath(joinpath(dirname(pathof(@__MODULE__)),".."))

mutable struct ProgramState
	phase::Int
	phases::Vector{Function}
	graphs::Dict{NodeID,QuellerGraph}

	strategy::Strategy.Choice
	dice::Vector{Die.Face}

	iop::IOParser

	debug_mode::Bool
	reset::Bool
	reset_phase::Bool
	exit::Bool
end

function ProgramState()
	phase = 1
	phases = [phase1,phase2,phase3,phase4,phase5]
	graphs = load_graphs(readdir("$(PKG_DIR)/graphs", join=true)...)

	strategy = rand(instances(Strategy.Choice))
	dice = Vector{Die.Face}()

	iop = IOParser([
		CMD.Debug()
		CMD.ResetAll()
		CMD.ResetPhase()
		CMD.Exit()
		CMD.Repeat()
		])

	cmds = Vector{CMD.Command}()
	return ProgramState(phase,phases,graphs,strategy,dice,iop,false,false,false,false)
end

handle_general_command(state,cmd::CMD.Debug) = (state.debug_mode = !state.debug_mode)
handle_general_command(state,cmd::CMD.ResetAll) = (state.reset = true)
handle_general_command(state,cmd::CMD.ResetPhase) = (state.reset_phase = true)
handle_general_command(state,cmd::CMD.Exit) = (state.exit = true)
handle_general_command(state,cmd::CMD.Command) = nothing

function main()
	state = ProgramState()
	while !state.exit
		state.phases[state.phase](state)

		state.reset_phase && (state.reset_phase = false; continue)
		state.reset && (state = ProgramState(); continue)

		state.phase = 1 + (state.phase % length(state.phases))
	end
end


function phase1(state)
	state.strategy == Strategy.Military && (graph = "phase_1_mili")
	state.strategy == Strategy.Corruption && (graph = "phase_1_corr")

	gc = GraphCrawler(graph,state.graphs,state.strategy,state.dice)

	# while !at_end()
	# 	msg, options = getcurrent(gc)

	# 	display_message(state.iop, msg)
	# 	input = read_input(state.iop, options)

	# 	input in options && (step!(gc,input); continue)
	# 	input isa CMD.Repeat && (continue)
	# 	input isa CMD.Command && handle_general_command(state,input)
	# 	input isa CMD.AbortingCommand && return nothing
	# end

end

function phase2(state)
	if state.strategy == Strategy.Military
		condition = """
		The Shadow's victory points are less than the corruption points after the Free Peoples' have chosen whether to reveal.
		"""
		change_strategy = Strategy.Corruption
	elseif state.strategy == Strategy.Corruption
		condition = """
		The corruption points are less than the Shadow's victory points after the Free Peoples' have chosen whether to reveal.
		"""
		change_strategy = Strategy.Military
	end

	display_message(state.iop, condition)
	while true
		input = read_input(state.iop, [CMD.True(), CMD.False()])
		input isa CMD.False && return nothing
		input isa CMD.True && return state.strategy = change_strategy

		input isa CMD.Command && handle_general_command(state,input)
		input isa CMD.AbortingCommand && return nothing
		input isa CMD.Repeat && return phase2(state)
	end
end

function phase3(state)

end

function phase4(state)
	diefaces = instances(Die.Face)
	legends = Die.char.(diefaces).*": ".*string.(diefaces)

	msg = """
	Roll all action dice not in the hunt box. Place all Eye results in the hunt box and input the remaining dice here.

	$(strvec2str(legends))
	"""

	display_message(state.iop, msg)
	while true
		dice = read_input(state.iop, [CMD.Dice()])
		dice isa CMD.Dice && return state.dice = dice.dice

		dice isa CMD.Command && handle_general_command(state,dice)
		dice isa CMD.AbortingCommand && return nothing
		dice isa CMD.Repeat && return phase4(state)
	end
end

function phase5(state)

end


################################################################################

include("graphviz.jl")

function check_queller_graphs()
	state = ProgramState()
	graphs = state.graphs
	# graphs = load_graphs(GRAPH_SOURCES...)

	println("\nAll graphs in PostScript can be found in Queller/graph_output.")
	graph_output(f) = joinpath(PKG_DIR, "graph_output", splitext(basename(f))[1]*".ps")

	for f in getfield.(values(graphs),:source_file)
		graph2ps(f, graph_output(f))
	end

	unjumped = get_graphs_not_jumped_to(values(graphs))
	println("\nGraphs that are not jumped to from another graph:\n$(strvec2str(unjumped))")
end


end
