module Queller

export load_graphs,
	graph2dot


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
	next_node::String

	StartNode(;id, text, next_node) = new(valid_id(id), text, valid_id(next_node))
end

node2dot(n::StartNode) =
	"""
		$(n.id) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(n.text))"];
		$(n.id) -> $(n.next_node);

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
	next_node::String

	PerformAction(;id, action, next_node) =
		new(valid_id(id), action, valid_id(next_node))
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

	YesNoCondition(;id, condition, next_node_yes, next_node_no) =
		new(valid_id(id), condition, valid_id(next_node_yes), valid_id(next_node_no))
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
	text::String
	next_node::String
	subgraph_id::String

	JumpToSubgraph(;id, text, next_node, subgraph_id) =
		new(valid_id(id), text, valid_id(next_node), valid_id(subgraph_id))
end

node2dot(n::JumpToSubgraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.text))"];
		$(n.id) -> $(n.next_node);

	"""

struct ReturnFromSubgraph <: GraphNode
	id::String
	jump_text::String

	ReturnFromSubgraph(;id, jump_text) = new(valid_id(id), jump_text)
end

node2dot(n::ReturnFromSubgraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.jump_text))"];

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


################################################################################





end
