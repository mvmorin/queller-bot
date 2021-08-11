module Queller

export load_graphs,
	graph2pdf,
	graph2ps


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
		$(n.id) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(n.text))\n($(escape_string(n.id)))"];
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
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.text))\n($(escape_string(n.jump_graph)))"];
		$(n.id) -> $(n.next);

	"""

struct ReturnFromGraph <: GraphNode
	id::String
	jump_text::String

	ReturnFromGraph(;id, jump_text="Continue from where\nyou jumped to this\n graph.") = new(valid_id(id), jump_text)
end

node2dot(n::ReturnFromGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.jump_text))"];

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


struct BinaryCondition <: GraphNode
	id::String
	condition::String
	next_true::String
	next_false::String

	BinaryCondition(;id, condition, next_true, next_false) =
		new(valid_id(id), condition, valid_id(next_true), valid_id(next_false))
end

node2dot(n::BinaryCondition) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(n.condition))"];
		$(n.id) -> $(n.next_true) [label = "True"];
		$(n.id) -> $(n.next_false) [label = "False"];

	"""


struct MultipleChoice <: GraphNode
	id::String
	conditions::String
	nexts::Vector{String}

	MultipleChoice(;id, conditions, nexts) =
		new(valid_id(id), conditions, valid_id.(nexts))
end

function node2dot(n::MultipleChoice)
	dot_node = """
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(n.conditions))"];
	"""

	for (i, nx) in enumerate(n.nexts)
		dot_node *= """
			$(n.id) -> $(nx) [label = "$(i)"];
		"""
	end
	return dot_node*'\n'
end





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
		$(n.id) [shape=box, style=filled, fillcolor=orange, label="$(escape_string(text))"];
		$(n.id) -> $(n.next);

	"""
end


struct CheckStrategy <: GraphNode
	id::String
	strategy::String
	next_true::String
	next_false::String

	CheckStrategy(;id, strategy, next_true, next_false) =
		new(valid_id(id), strategy, valid_id(next_true), valid_id(next_false))
end

function node2dot(n::CheckStrategy)
	text = """
	The $(n.strategy) strategy is used.
	"""
	return """
		$(n.id) [shape=box, style=filled, fillcolor=orange, label="$(escape_string(text))"];
		$(n.id) -> $(n.next_true) [label="True"];
		$(n.id) -> $(n.next_false) [label="False"];

	"""
end


################################################################################

DICE = Dict(
	'C' => "Character Die",
	'A' => "Army Die",
	'M' => "Muster Die",
	'H' => "Army/Muster Die",
	'P' => "Event Die",
	'E' => "Eye",
	'W' => "Will of the West", # Never used
	)

struct RollActionDice <: GraphNode
	id::String
	next::String

	RollActionDice(;id, next) = new(valid_id(id), valid_id(next))
end

node2dot(n::RollActionDice) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="Roll the action dice."];
		$(n.id) -> $(n.next);

	"""

struct AvailableModifiers <: GraphNode
	id::String
	next::String

	AvailableModifiers(;id, next) = new(valid_id(id), valid_id(next))
end

node2dot(n::AvailableModifiers) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="Check if an elven ring\n or Messenger of the Dark\n Tower is available."];
		$(n.id) -> $(n.next);

	"""

struct SetActiveDie <: GraphNode
	id::String
	next::String
	next_no_die::String

	die::Char
	may_use_ring::Bool

	SetActiveDie(;id, next, next_no_die, die, may_use_ring=false) =
		new(valid_id(id), valid_id(next), valid_id(next_no_die), die, may_use_ring)
end

function node2dot(n::SetActiveDie)
	prio_list = [DICE[n.die]]
	if n.die == 'A'
		push!(prio_list, "$(DICE['H']) as $(DICE['A'])")
		push!(prio_list, "$(DICE['M']) and Messenger of the Dark Tower as $(DICE['A'])")
	elseif n.die == 'M'
		push!(prio_list, "$(DICE['H']) as a $(DICE['M'])")
		push!(prio_list, "$(DICE['A']) and Messenger of the Dark Tower as $(DICE['M'])")
	end

	if n.may_use_ring
		push!(prio_list, "A random non-*preferred* die and an Elven Ring as $(DICE[n.die])")
	end


	text = """
	Set the first matching die as the Active Die:

	"""
	for (i, d) in enumerate(prio_list)
		text *= "$(i). $(d)\n"
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

graph2ps(file_in, file_out="out.ps") = graph2format(file_in, "ps", file_out)
graph2pdf(file_in, file_out="out.pdf") = graph2format(file_in, "pdf", file_out)

function graph2format(file_in, format, file_out)
	g = load_graphs(file_in)[1] # Only take the first start point of the graph
	s = graph2dot(g)

	open(`dot -T$(format) -o $(file_out)`, write = true) do io
		print(io,s)
	end
end


################################################################################





end
