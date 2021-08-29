module Queller

using TextWrap

export load_graphs,
	check_queller_graphs,
	main

const PKG_DIR = abspath(joinpath(dirname(pathof(@__MODULE__)),".."))

################################################################################

not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)
strvec2str(v,sep='\n') = isempty(v) ? "" : reduce((s,t) -> s*sep*t, v)

################################################################################

include("dice_and_strategy.jl")
include("cli.jl")
include("graph.jl")
# include("crawler.jl")

################################################################################


mutable struct ProgramState
	phase::Int
	phases::Vector{Function}
	graphs::Dict{String,QuellerGraph}

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

	# Load all graphs in Queller/graphs directory
	graph_files = filter(p-> splitext(p)[2] == ".jl", readdir("$(PKG_DIR)/graphs", join=true))
	graphs = load_graphs(graph_files...)

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

function resolve_decision_graph(state,graph;modt_available=false,ring_available=false)
	gc = GraphCrawler(graph, state.graphs, state.strategy, state.dice, modt_available=modt_available, ring_available=ring_available)

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

function phase1(state)
	state.strategy == Strategy.Military && (graph = "phase_1_mili")
	state.strategy == Strategy.Corruption && (graph = "phase_1_corr")

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

	callback(cmd::CMD.False) = nothing
	callback(cmd::CMD.True) = (state.strategy = change_strategy)
	!print_read_process(state, condition, [CMD.True(),CMD.False()], callback) && return
end

function phase3(state)
	state.strategy == Strategy.Military && (graph = "phase_3_mili")
	state.strategy == Strategy.Corruption && (graph = "phase_3_corr")

	resolve_decision_graph(state, graph)
end

function phase4(state)
	diefaces = instances(Die.Face)
	legends = Die.char.(diefaces).*": ".*string.(diefaces)

	msg = """
	Roll all action dice not in the hunt box. Place all Eye results in the hunt box and input the remaining dice here.

	$(strvec2str(legends))
	"""

	callback(cmd) = (state.dice = cmd.dice)
	!print_read_process(state, msg, [CMD.Dice()], callback) && return
end

function phase5(state)
	menu = """
	Available Dice: $(strvec2str(sort(Die.char.(state.dice)),','))

	Select phase 5 action.

	1. Choose Shadow action
	2. Resolve a card effect
	3. Resolve a battle
	4. Recruit a minion as Shadow's final action with die set aside earlier
	5. Change the available dice (use this if the bot's available dice do not match reality)
	6. End turn and go to phase 1
	"""
	choice = Ref(0)
	menu_callback(cmd) = (choice[] = cmd.opt)
	!print_read_process(state, menu, CMD.Option.(1:6), menu_callback) && return

	if choice[] == 1
		ret = phase5_action(state)
		isnothing(ret) && return

	elseif choice[] == 2
		ret = resolve_decision_graph(state, "event_cards_resolve_effect")
		isnothing(ret) && return

	elseif choice[] == 3
		ret = resolve_decision_graph(state, "battle")
		isnothing(ret) && return

	elseif choice[] == 4
		ret = resolve_decision_graph(state, "muster_minion_selection")
		isnothing(ret) && return

	elseif choice[] == 5
		diefaces = instances(Die.Face)
		legends = Die.char.(diefaces).*": ".*string.(diefaces)

		msg = """
		Input the available action dice.

		$(strvec2str(legends))
		"""
		dice_callback(cmd) = (state.dice = cmd.dice)
		!print_read_process(state, msg, [CMD.Dice()], dice_callback) && return
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

function phase5_action(state)
	state.strategy == Strategy.Military && (graph = "select_action_mili")
	state.strategy == Strategy.Corruption && (graph = "select_action_corr")

	msg = "The Shadow have an Elven ring."
	ring_available = Ref(false)
	ring_callback(cmd::CMD.False) = (ring_available[] = false)
	ring_callback(cmd::CMD.True) = (ring_available[] = true)
	!print_read_process(state, msg, [CMD.True(), CMD.False()], ring_callback) && return

	msg = """
	The Mouth of Sauron is recruited and his "Messenger of the Dark Tower" ability have not been used this turn.
	"""
	modt_available = Ref(false)
	modt_callback(cmd::CMD.False) = (modt_available[] = false)
	modt_callback(cmd::CMD.True) = (modt_available[] = true)
	!print_read_process(state, msg, [CMD.True(), CMD.False()], modt_callback) && return

	gc = resolve_decision_graph(state, graph, modt_available=modt_available[], ring_available=ring_available[])

	isnothing(gc) && return
	if !isnothing(gc.active_die) && gc.active_die.used
		i = findfirst(==(gc.active_die.die), state.dice)
		deleteat!(state.dice, i)
	end
	return true
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
