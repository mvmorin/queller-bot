module Queller

using TextWrap

export load_graphs,
	check_queller_graphs,
	main

################################################################################

not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)
strvec2str(v,sep='\n') = reduce((s,t) -> s*sep*t, v)

################################################################################

include("commands.jl")
include("dice_and_strategy.jl")
include("graph.jl")
include("crawler.jl")

################################################################################

struct IOParser
	cmds::Vector{CMD.Command}
	in::IO
	out::IO

	IOParser(cmds) = new(cmds, stdin, stdout)
end

Base.print(iop::IOParser,a...) = print(iop.out, a...)
Base.println(iop::IOParser,a...) = println(iop.out, a...)
function Base.readline(iop::IOParser)
	str = readline(iop.in)
	!isopen(iop.in) && error("Input stream closed")
	return lstrip(str)
end

function read_input(iop::IOParser, inputs::Vector{T}) where {T <: CMD.Command}
	prompt = isempty(inputs) ?
		"> " : "["*strvec2str(string.(inputs), '/')*"] > "
	print(iop, prompt)

	str = readline(iop)

	isempty(inputs) && isempty(str) && return nothing

	cmd = CMD.parse([inputs; iop.cmds], str)
	!isnothing(cmd) && return cmd

	!isempty(str) && println(iop,"Invalid input.")
	read_input(iop, inputs)
end

function read_dice(iop::IOParser)
	prompt = "[$(strvec2str(Die.char.(instances(Die.Face)),','))] > "
	print(iop, prompt)

	str = readline(iop)
	str = String(filter(!isspace, collect(str))) # remove any spaces

	cmd = CMD.parse(iop.cmds, str)
	!isnothing(cmd) && return cmd

	dice = Die.parse(str)
	!isnothing(dice) && return dice

	println(iop, "Invalid input.")
	read_dice(iop)
end

function display_message(iop::IOParser,msg,header="-"^10)
	println(iop, header)
	msg = lstrip(rstrip(msg))
	for p in split(msg, '\n')
		println(iop, wrap(p, width=50))
	end
end

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
handle_general_command(state,cmd::CMD.Repeat) = nothing

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
		dice = read_dice(state.iop)
		dice isa Vector{Die.Face} && return state.dice = dice

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
