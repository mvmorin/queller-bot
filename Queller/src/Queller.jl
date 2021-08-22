module Queller

using TextWrap

export load_graphs,
	check_queller_graphs,
	main

const PKG_DIR = abspath(joinpath(dirname(pathof(@__MODULE__)),".."))

################################################################################

not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)
strvec2str(v,sep='\n') = reduce((s,t) -> s*sep*t, v)

################################################################################

include("dice_and_strategy.jl")
include("cli.jl")
include("graph.jl")
include("crawler.jl")

################################################################################


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
	graphs = load_graphs(filter(p-> splitext(p)[2] == ".jl", readdir("$(PKG_DIR)/graphs", join=true))...)

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

function read_and_process(state,options)
	# read and handle general commands until something that requires the output
	# to be updated is received
	input = read_input(state.iop, options)

	input in options && return input
	input isa CMD.Command && handle_general_command(state,input)
	input isa Union{CMD.AbortingCommand,CMD.Repeat} && return input

	read_and_process(state, options)
end

function resolve_decision_graph(state,graph)
	# returns nothing if was aborted, otherwise it returns the graph crawler
	gc = GraphCrawler(graph,state.graphs,state.strategy,state.dice)

	while !at_end(gc)
		msg, options = getinteraction(gc)
		display_message(state.iop, msg)

		cmd = read_and_process(state, options)
		cmd in options && proceed!(gc,cmd)
		cmd isa CMD.AbortingCommand && return
	end

	return gc
end

function phase1(state)
	state.strategy == Strategy.Military && (graph = NodeID("phase_1_mili"))
	state.strategy == Strategy.Corruption && (graph = NodeID("phase_1_corr"))

	resolve_decision_graph(state, graph)
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
	cmd = read_and_process(state, [CMD.True(),CMD.False()])
	cmd isa CMD.False && return nothing
	cmd isa CMD.True && return state.strategy = change_strategy
	cmd isa CMD.AbortingCommand && return
	cmd isa CMD.Repeat && return phase2(state)
end

function phase3(state)
	state.strategy == Strategy.Military && (graph = NodeID("phase_3_mili"))
	state.strategy == Strategy.Corruption && (graph = NodeID("phase_3_corr"))

	resolve_decision_graph(state, graph)
end

function phase4(state)
	diefaces = instances(Die.Face)
	legends = Die.char.(diefaces).*": ".*string.(diefaces)

	msg = """
	Roll all action dice not in the hunt box. Place all Eye results in the hunt box and input the remaining dice here.

	$(strvec2str(legends))
	"""

	display_message(state.iop, msg)
	cmd = read_and_process(state, [CMD.Dice()])
	cmd isa CMD.Dice && state.dice = cmd.dice
	cmd isa CMD.Repeat && return phase4(state)
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
