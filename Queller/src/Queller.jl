module Queller

export load_graphs,
	graph2dot,
	graph2ps


################################################################################
# Notes
#
# Character Die: C
# Army Die: A
# Muster Die: M
# Army/Muster Die: H
# Event Die: P (palantir)
# Eye: E
#
# SP = shadow player
# FP = free peoples player


################################################################################

function valid_id(id::String)
	valid_char(c) = islowercase(c) | (c == '_') | isdigit(c)
	islowercase(id[1]) || error("First character in Node ID needs to be lower case character.")
	all(valid_char, id) || error("Node ID can only contain lower case letters, digits and underscores.")
	return id
end

abstract type GraphNode end



################################################################################

struct QuellerGraph
	root_node::String
	nodes::Dict{String,GraphNode}
end

function graph2dot(g::QuellerGraph)
	body = mapreduce(node2dot, *, values(g.nodes))

	return """
		digraph {
			rankdir=TB

		$(body)
		}
		"""
end




################################################################################

struct StartNode <: GraphNode
	id::String
	text::String
	next::String

	StartNode(;id, text, next) = new(valid_id(id), text, valid_id(next))
end

node2dot(n::StartNode) =
	"""
		$(n.id) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(n.text))"];
		$(n.id) -> $(n.next);

	"""

struct EndNode <: GraphNode
	id::String
	text::String

	EndNode(;id, text="End of Action") = new(valid_id(id), text)
end

node2dot(n::EndNode) =
	"""
		$(n.id) [shape=diamond, style=filled, fillcolor=red, label="$(escape_string(n.text))"];

	"""


################################################################################

struct PerformAction <: GraphNode
	id::String
	action::String
	next::String

	PerformAction(;id, action, next) =
		new(valid_id(id), action, valid_id(next))
end

node2dot(n::PerformAction) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="$(escape_string(n.action))"];
		$(n.id) -> $(n.next);

	"""


struct YesNoCondition <: GraphNode
	id::String
	condition::String
	next_yes::String
	next_no::String

	YesNoCondition(;id, condition, next_yes, next_no) =
		new(valid_id(id), condition, valid_id(next_yes), valid_id(next_no))
end

node2dot(n::YesNoCondition) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(n.condition))"];
		$(n.id) -> $(n.next_yes) [label = "Yes"];
		$(n.id) -> $(n.next_no) [label = "No"];

	"""



################################################################################

struct JumpToGraph <: GraphNode
	id::String
	text::String
	next::String
	jump_graph::String

	JumpToGraph(;id, text, next, jump_graph) =
		new(valid_id(id), text, valid_id(next), valid_id(jump_graph))
end

node2dot(n::JumpToGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.text))"];
		$(n.id) -> $(n.next);

	"""

struct ReturnFromGraph <: GraphNode
	id::String
	jump_text::String

	ReturnFromGraph(;id, jump_text="Continue from where\nyou jumped to this\n graph") = new(valid_id(id), jump_text)
end

node2dot(n::ReturnFromGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.jump_text))"];

	"""



################################################################################

struct SetStrategy <: GraphNode
	id::String
	strategy::String
	next::String

	SetStrategy(;id, strategy, next) = new(valid_id(id), strategy, valid_id(next))
end

function node2dot(n::SetStrategy)
	text = """
	Use the $(n.strategy) strategy
	until prompted otherwise.
	"""
	return """
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="$(escape_string(text))"];
		$(n.id) -> $(n.next);

	"""
end



################################################################################
#
# Dice are represented by the following characters
#
# Character Die: C
# Army Die: A
# Muster Die: M
# Army/Muster Die: H
# Event Die: P (palantir)
# Eye: E
# Will of the West: W (not used)

DICE_DICT = Dict(
	'C' => "Character Die",
	'A' => "Army Die",
	'M' => "Muster Die",
	'H' => "Army/Muster Die",
	'P' => "Event Die",
	'E' => "Eye",
	'W' => "Will of the West")

struct RollActionDice <: GraphNode
	id::String
	next::String

	RollActionDice(;id, next) = new(valid_id(id), valid_id(next))
end

node2dot(n::RollActionDice) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="Roll action dice."];
		$(n.id) -> $(n.next);

	"""

struct AvailableModifiers <: GraphNode
	id::String
	next::String

	AvailableModifiers(;id, next) = new(valid_id(id), valid_id(next))
end

node2dot(n::AvailableModifiers) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="Check if an elven ring\n or Messenger of the Dark\n Tower is available"];
		$(n.id) -> $(n.next);

	"""

struct SelectActiveDie <: GraphNode
	id::String
	next::String
	next_no_die::String

	priority::String # String of die to use
	may_use_ring::Bool
	may_use_messenger::Bool

	SelectActiveDie(;id, next, next_no_die, priority, may_use_ring=false, may_use_messenger=false) =
		new(valid_id(id), valid_id(next), valid_id(next_no_die), priority, may_use_ring, may_use_messenger)
end

function node2dot(n::SelectActiveDie)
	prio_list = [DICE_DICT[die] for die in n.priority]

	if n.priority[1] == 'A'
		n.may_use_messenger && push!(prio_list, "Muster Die and Messenger of the Dark Tower")
	elseif n.priority[1] == 'M'
		n.may_use_messenger && push!(prio_list, "Army Die and Messenger of the Dark Tower")
	end

	n.may_use_ring && push!(prio_list, "Random Non-*Preferred* Die and an Eleven Ring")

	text = """
	Set the active die to one of the
	following in descending priority.

	"""
	for (i, die) in enumerate(prio_list)
		text *= "$(i). $(die)\n"
	end
	if 'H' in n.priority || n.may_use_ring
		text *= """

		For the Elven Rings and Army/Muster dice,
		convert to the highest priority die when
		instructed to use the active die.
		"""
	end

	return """
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="$(escape_string(text))"];
		$(n.id) -> $(n.next) [label="Die Available"];
		$(n.id) -> $(n.next_no_die) [label="No Matching Die"];

	"""
end


struct UseActiveDie <: GraphNode
	id::String
	next::String

	UseActiveDie(;id, next) = new(valid_id(id), valid_id(next))
end

node2dot(n::UseActiveDie) =
	"""
		$(n.id) [shape=hexagon, style=filled, fillcolor=pink, label="Use the Active Die to:"];
		$(n.id) -> $(n.next);

	"""

struct DieHasBeenUsed <: GraphNode
	id::String
	next_used::String
	next_not_used::String

	DieHasBeenUsed(;id, next_used, next_not_used) = new(valid_id(id), valid_id(next_used), valid_id(next_not_used))
end

node2dot(n::DieHasBeenUsed) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="Has a die been used?"];
		$(n.id) -> $(n.next_used) [label="Yes"];
		$(n.id) -> $(n.next_not_used) [label="No"];

	"""


struct ReserveDie <: GraphNode
	id::String
	next::String

	ReserveDie(;id, next) = new(valid_id(id), valid_id(next))
end
node2dot(n::ReserveDie) =
	"""
		$(n.id) [shape=hexagon, style=filled, fillcolor=pink, label="Set aside die to use\nmuster a minion as\n last action "];
		$(n.id) -> $(n.next);

	"""





################################################################################

function unique_node_ids(nodes)
	ids = getfield.(nodes, :id)
	return length(ids) == length(unique(ids))
end

function unique_root_ids(graphs)
	ids = get_field.(graphs, :root_node)
	return length(ids) == length(unique(ids))
end

function load_graphs(file)
	nodes = include(file)
	unique_node_ids(nodes) || error("Error loading nodes, not all ids are unique.")
	start_nodes = filter(n -> isa(n, StartNode), nodes)
	nodes_d = Dict(n.id => n for n in nodes)

	return [QuellerGraph(start.id, nodes_d) for start in start_nodes]
end

function load_graphs(f_head,f_tail...)
	graphs = load_graphs(f_head)
	for f in f_tail
		graphs = [graphs; load_graphs(f)]
	end
	unique_root_ids(graphs) || error("Error loading graphs, not all root node ids are unique.")
	return Dict(g.root_node => g for g in graphs)
end



################################################################################

function graph2dot(file_in, file_out=nothing)
	g = load_graphs(file_in)[1] # Only take the first start point of the graph
	s = graph2dot(g)

	isnothing(file_out) && (file_out = file_in*".gv")

	open(file_out, "w") do f
		write(f,s)
	end
end

function graph2ps(file_in)
	g = load_graphs(file_in)[1] # Only take the first start point of the graph
	s = graph2dot(g)

	open(`dot -Tps -o out.ps`, write = true) do io
		print(io,s)
	end
end


################################################################################





end
