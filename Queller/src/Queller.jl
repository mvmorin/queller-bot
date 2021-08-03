module Queller

greet() = print("Hello")

export load_graph,
	load_graphs,
	graph2dot


################################################################################
# Graph and node type

function valid_id(id::String)
	valid_char(c) = islowercase(c) | (c == '_') | isdigit(c)
	islowercase(id[1]) || error("First character in Node ID needs to be lower case character.")
	all(valid_char, id) || error("Node ID can only contain lower case letters, digits and underscores.")
	return id
end

abstract type GraphNode end

################################################################################


struct EndNode <: GraphNode
	id::String
	text::String

	EndNode(id, text) = new(valid_id(id), text)
end
EndNode(id) = EndNode(id,"End of Action")
node2dot(n::EndNode) =
	"""
		$(n.id) [shape=diamond, style=filled, fillcolor=red, label="$(escape_string(n.text))"];

	"""


################################################################################

struct PerformAction <: GraphNode
	id::String
	action::String
	next_node::String

	PerformAction(id, action, next_node) = new(valid_id(id), action, valid_id(next_node))
end
node2dot(n::PerformAction) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="$(escape_string(n.action))"];
		$(n.id) -> $(n.next_node);

	"""


struct YesNoCondition <: GraphNode
	id::String
	condition::String
	next_node_yes::String
	next_node_no::String

	YesNoCondition(id, condition, next_node_yes, next_node_no) = new(valid_id(id), condition, valid_id(next_node_yes), valid_id(next_node_no))
end
node2dot(n::YesNoCondition) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(n.condition))"];
		$(n.id) -> $(n.next_node_yes) [label = "Yes"];
		$(n.id) -> $(n.next_node_no) [label = "No"];

	"""

################################################################################

struct JumpToSubgraph <: GraphNode
	id::String
	jump_text::String
	next_node::String
	subgraph_start_id::String

	JumpToSubgraph(id, jump_text, next_node, subgraph_start_id) = new(valid_id(id), jump_text, valid_id(next_node), valid_id(subgraph_start_id))
end
node2dot(n::JumpToSubgraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.jump_text))"];
		$(n.id) -> $(n.next_node);

	"""

struct ReturnFromSubgraph <: GraphNode
	id::String
	jump_text::String

	ReturnFromSubgraph(id, jump_text) = new(valid_id(id), jump_text)
end
node2dot(n::ReturnFromSubgraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.jump_text))"];

	"""


################################################################################
struct QuellerGraph
	id::String
	text::String
	root_node::String

	nodes::Dict{String,GraphNode}

	function QuellerGraph(id, text, root_node)
		graph_id = valid_id(id)
		text = text
		root_node = root_node
		nodes = Dict{String, GraphNode}()

		new(id, text, root_node, nodes)
	end
end

function add!(g::QuellerGraph, n::GraphNode)
	n.id in keys(g.nodes) && error("Node ID already exists in graph")
	g.nodes[n.id] = n
	return g
end

function graph2dot(g::QuellerGraph)
	# ToDo: Add the implicit start node
# node2dot(n::StartNode) =
# 	"""
# 		$(n.id) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(n.text))"];
# 		$(n.id) -> $(n.next_node);

# 	"""

	body = mapreduce(node2dot, *, values(g.nodes))
	return "digraph {\nrankdir=TB;\n" * body * "}"
end

load_graph(file) = include(file)

function load_graphs(files...)
	graphs = Dict{String,QuellerGraph}()
	for file in files
		g = load_graph(file)
		graphs[g.start_id] = g
	end
	return graphs
end

function graph2dot(file_in, file_out)
	g = load_graph(file_in)
	s = graph2dot(g)
	open(file_out, "w") do f
		write(f,s)
	end
end


################################################################################





end
