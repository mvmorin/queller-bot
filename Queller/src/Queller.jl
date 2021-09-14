module Queller

using TextWrap

export load_graphs,
	check_queller_graphs,
	main

const PKG_DIR = abspath(joinpath(dirname(pathof(@__MODULE__)),".."))

################################################################################

not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)
strvec2str(v,sep='\n') = isempty(v) ? "" : reduce((s,t) -> s*sep*t, v)
fieldsdefined(obj) = all(i -> isdefined(obj,i), 1:nfields(obj))

################################################################################

include("dice_and_strategy.jl")
include("cli.jl")
include("graph.jl")
include("quellerstate.jl")
include("crawler.jl")

################################################################################

mutable struct ProgramState
	phase::Int
	phases::Vector{Function}
	graphs::Dict{String,QuellerGraph}

	available_dice::Vector{Die.Face}

	iop::IOParser

	reset::Bool
	reset_phase::Bool
	exit::Bool
end

function ProgramState()
	phase = 1
	phases = [phase1,phase2,phase3,phase4,phase5]

	# Load all graphs in Queller/graphs directory
	graph_files = filter(p-> splitext(p)[2] == ".jl", readdir("$(PKG_DIR)/graphs", join=true))
	graphs = load_graphs(graph_files...)

	available_dice = Vector{Die.Face}()

	iop = IOParser([
		CMD.ResetPhase()
		CMD.Exit()
		CMD.Repeat()
		CMD.Phase(length(phases))
		CMD.Help()
		])

	cmds = Vector{CMD.Command}()
	return ProgramState(phase,phases,graphs,available_dice,iop,false,false,false)
end

greeting_str = """
Queller: War of the Ring Shadow AI

Please read the general information and have it and the glossary available.

This program will present a number of selections, true/false statements, and actions for each of the 5 game phases. Simply answer and perfom these when they are presented to you.

Type "help" for more information regarding the operation of the program.
"""

help_str = """
# Inputs #
All inputs are case insensitive and can in many cases be shorten to one letter, i.e., "t" for "true", "f" for "false", "u" for "undo" etc.

The valid options for a query are given by the input prompt. If the options are separated by "/" only one of the options should be given. If they are separated by "," several options can be given separated either by spaces or nothing at all.

# Commands #
The following commands can (almost) always be used when prompted for input.

help        :: Shows this help message.
exit        :: Exits the program.
undo        :: Undo the latest input and step back. Note, everything can not be undone, use the "reset" or "phase" command in these circumstances.
repeat      :: Repeats the latest query.
reset       :: Reset and restart the current phase.
phase <nbr> :: Jumps to the beginning of a phase, e.g., type "phase 3" to jump to phase 3
"""



################################################################################

function print_read_process(state, msg, options, callback, silent_options=Vector{CMD.Command}())
	display_message(state.iop, msg)

	while true
		cmd = read_input(state.iop, options, silent_options)

		if cmd in options || cmd in silent_options
			callback(cmd)
			return true
		end

		cmd isa CMD.Command && handle_general_command(state,cmd)
		cmd isa CMD.Repeat && return print_read_process(state, msg, options, callback, silent_options)
		cmd isa CMD.AbortingCommand && return false
	end
end

function resolve_decision_graph(state, graph)
	gc = GraphCrawler(graph, state.graphs, state.available_dice)

	abort = Ref(false)
	callback(cmd) = proceed!(gc, cmd)
	callback(cmd::CMD.Undo) = !undo!(gc) && (abort[] = !print_read_process(state, "Cannot undo more.", [CMD.Blank()], x->nothing))

	while !at_end(gc)
		msg, options = getinteraction(gc)
		!print_read_process(state, msg, options, callback, [CMD.Undo()]) && return false
		abort[] && return false
	end

	state.available_dice = get_available_dice(gc)
	return true
end


################################################################################

function main()
	state = ProgramState()
	display_message(state.iop, greeting_str)

	while !state.exit
		state.phases[state.phase](state)

		state.reset_phase && (state.reset_phase = false; continue)

		state.phase = 1 + (state.phase % length(state.phases))
	end
end

handle_general_command(state,cmd::CMD.Command) = nothing
handle_general_command(state,cmd::CMD.ResetPhase) = (state.reset_phase = true)
handle_general_command(state,cmd::CMD.Exit) = (state.exit = true)
handle_general_command(state,cmd::CMD.Phase) = (state.reset_phase = true; state.phase = cmd.nbr)
handle_general_command(state,cmd::CMD.Help) = display_message(state.iop, help_str)


phase1(state) = graph_phase(state, "phase_1", "Phase 1")
phase2(state) = graph_phase(state, "phase_2", "Phase 2")
phase3(state) = graph_phase(state, "phase_3", "Phase 3")
phase4(state) = graph_phase(state, "phase_4", "Phase 4")

function graph_phase(state, graph, name)
	display_message(state.iop, name)
	resolve_decision_graph(state, graph)
end

function phase5(state)
	menu = """
	Available Dice: $(strvec2str(sort(Die.char.(state.available_dice)),','))

	Select phase 5 action.

	1. Choose Shadow action
	2. Resolve a card effect
	3. Resolve a battle
	4. Recruit a minion as Shadow's final action with die set aside earlier
	5. Change the available dice (use this if the bot's available dice do not match reality)
	6. End turn and go to phase 1
	"""

	graphs = [
			  "phase_5",
			  "event_cards_resolve_effect",
			  "battle",
			  "muster_minion_selection",
			  "adjust_dice",
			  ]

	choice = Ref(0)
	menu_callback(cmd) = (choice[] = cmd.opt)
	!print_read_process(state, menu, CMD.Option.(1:6), menu_callback) && return

	if 1 <= choice[] <= 5
		!resolve_decision_graph(state, graphs[choice[]]) && return

	elseif choice[] == 6
		# Confirm exit
		msg = "Exit phase 5 and return to phase 1."
		exit = Ref(false)

		exit_callback(cmd::CMD.False) = (exit[] = false)
		exit_callback(cmd::CMD.True) = (exit[] = true)

		!print_read_process(state, msg, [CMD.True(), CMD.False()], exit_callback) && return

		exit[] && return
	end

	phase5(state)
end

################################################################################

include("graphviz.jl")

function check_queller_graphs()
	state = ProgramState()
	graphs = state.graphs

	println("\nAll graphs in PostScript can be found in Queller/graph_output.")
	graph_output_file(f) = joinpath(PKG_DIR, "graph_output", splitext(basename(f))[1]*".ps")

	for f in getfield.(values(graphs),:source_file)
		graph2ps(f, graph_output_file(f))
	end

	unjumped = get_graphs_not_jumped_to(values(graphs))
	println("\nGraphs that are not jumped to from another graph:\n$(strvec2str(unjumped))")

	return
end


end
