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

	queller::QuellerState

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

	queller = QuellerState()

	iop = IOParser([
		CMD.ResetAll()
		CMD.ResetPhase()
		CMD.Exit()
		CMD.Repeat()
		])

	cmds = Vector{CMD.Command}()
	return ProgramState(phase,phases,graphs,queller,iop,false,false,false)
end


handle_general_command(state,cmd::CMD.ResetAll) = (state.reset = true)
handle_general_command(state,cmd::CMD.ResetPhase) = (state.reset_phase = true)
handle_general_command(state,cmd::CMD.Exit) = (state.exit = true)
handle_general_command(state,cmd::CMD.Command) = nothing

function print_read_process(state, msg, options, callback)
	display_message(state.iop, msg)

	while true
		cmd = read_input(state.iop, options)
		cmd in options && (callback(cmd); return true)

		cmd isa CMD.Command && handle_general_command(state,cmd)
		cmd isa CMD.Repeat && return print_read_process(state, msg, options, callback)
		cmd isa CMD.AbortingCommand && return false
	end
end

function resolve_decision_graph(state, graph)
	state.queller.active_die = nothing
	gc = GraphCrawler(graph, state.graphs, state.queller)

	callback(cmd) = proceed!(gc, cmd)

	while !at_end(gc)
		msg, options = getinteraction(gc)
		!print_read_process(state, msg, options, callback) && return
	end

	return gc
end


################################################################################

function main()
	state = ProgramState()
	while !state.exit
		state.phases[state.phase](state)

		state.reset_phase && (state.reset_phase = false; continue)
		state.reset && (state = ProgramState(); continue)

		state.phase = 1 + (state.phase % length(state.phases))
	end
end

phase1(state) = resolve_decision_graph(state, "phase_1")
phase2(state) = resolve_decision_graph(state, "phase_2")
phase3(state) = resolve_decision_graph(state, "phase_3")
phase4(state) = resolve_decision_graph(state, "phase_4")

function phase5(state)
	menu = """
	Available Dice: $(strvec2str(sort(Die.char.(state.queller.available_dice)),','))

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
		ret = resolve_decision_graph(state, graphs[choice[]])
		isnothing(ret) && return

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
