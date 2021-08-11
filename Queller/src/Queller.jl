module Queller

export load_graphs



################################################################################
allunique(v) = length(v) == length(unique(v))

################################################################################

function valid_id(id::String)
	valid_char(c) = islowercase(c) | (c == '_') | isdigit(c)
	islowercase(id[1]) || error("First character in Node ID needs to be lower case character.")
	all(valid_char, id) || error("Node ID can only contain lower case letters, digits and underscores.")
	return id
end

abstract type GraphNode end



################################################################################

struct StartNode <: GraphNode
	id::String
	text::String
	next::String

	StartNode(;id, text, next) = new(valid_id(id), text, valid_id(next))
end
children(n::StartNode) = [n.next]

struct EndNode <: GraphNode
	id::String
	text::String

	EndNode(;id, text="End of Action") = new(valid_id(id), text)
end
children(n::EndNode) = []


################################################################################

struct JumpToGraph <: GraphNode
	id::String
	text::String
	next::String
	jump_graph::String

	JumpToGraph(;id, text, next, jump_graph) =
		new(valid_id(id), text, valid_id(next), valid_id(jump_graph))
end
children(n::JumpToGraph) = [n.next]

struct ReturnFromGraph <: GraphNode
	id::String
	jump_text::String

	ReturnFromGraph(;id, jump_text="Continue from where\nyou jumped to this\n graph.") = new(valid_id(id), jump_text)
end
children(n::ReturnFromGraph) = []


################################################################################

struct PerformAction <: GraphNode
	id::String
	action::String
	next::String

	PerformAction(;id, action, next) =
		new(valid_id(id), action, valid_id(next))
end
children(n::PerformAction) = [n.next]

struct BinaryCondition <: GraphNode
	id::String
	condition::String
	next_true::String
	next_false::String

	BinaryCondition(;id, condition, next_true, next_false) =
		new(valid_id(id), condition, valid_id(next_true), valid_id(next_false))
end
children(n::BinaryCondition) = [n.next_true, n.next_false]

struct MultipleChoice <: GraphNode
	id::String
	conditions::String
	nexts::Vector{String}

	MultipleChoice(;id, conditions, nexts) =
		new(valid_id(id), conditions, valid_id.(nexts))
end
children(n::MultipleChoice) = n.nexts


################################################################################

struct SetStrategy <: GraphNode
	id::String
	strategy::String
	next::String

	SetStrategy(;id, strategy, next) = new(valid_id(id), strategy, valid_id(next))
end
children(n::SetStrategy) = [n.next]

struct CheckStrategy <: GraphNode
	id::String
	strategy::String
	next_true::String
	next_false::String

	CheckStrategy(;id, strategy, next_true, next_false) =
		new(valid_id(id), strategy, valid_id(next_true), valid_id(next_false))
end
children(n::CheckStrategy) = [n.next_true, n.next_false]

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
children(n::RollActionDice) = [n.next]

struct AvailableModifiers <: GraphNode
	id::String
	next::String

	AvailableModifiers(;id, next) = new(valid_id(id), valid_id(next))
end
children(n::AvailableModifiers) = [n.next]

struct SetActiveDie <: GraphNode
	id::String
	next::String
	next_no_die::String

	die::Char
	may_use_ring::Bool

	SetActiveDie(;id, next, next_no_die, die, may_use_ring=false) =
		new(valid_id(id), valid_id(next), valid_id(next_no_die), die, may_use_ring)
end
children(n::SetActiveDie) = [n.next, n.next_no_die]

struct UseActiveDie <: GraphNode
	id::String
	next::String

	UseActiveDie(;id, next) = new(valid_id(id), valid_id(next))
end
children(n::UseActiveDie) = [n.next]

################################################################################

struct QuellerGraph
	root_node::String
	nodes::Dict{String,GraphNode}
end

function unique_node_ids(nodes)
	ids = getfield.(nodes, :id)
	return allunique(ids)
end

function unique_root_ids(graphs)
	ids = get_field.(graphs, :root_node)
	return allunique(ids)
end

function all_children_exists(nodes)
	child_ids = mapreduce(children, vcat, nodes)
	ids = getfield.(nodes, :id)
	id_exists(id) = id in ids
	return all(id_exists.(child_ids))
end

function load_graphs(file)
	nodes = include(file)
	!unique_node_ids(nodes) && error("Error loading nodes, not all ids are unique.")
	!all_children_exists(nodes) && error("Error loading nodes, not all child nodes exists.")
	nodes_d = Dict(n.id => n for n in nodes)

	start_nodes = filter(n -> isa(n, StartNode), nodes)

	return [QuellerGraph(start.id, nodes_d) for start in start_nodes]
end

function load_graphs(files...)
	graphs = mapreduce(load_graph, vcat, files)
	!unique_root_ids(graphs) && error("Error loading graphs, not all root node ids are unique.")
	return Dict(g.root_node => g for g in graphs)
end

################################################################################

include("graphviz.jl")


end
