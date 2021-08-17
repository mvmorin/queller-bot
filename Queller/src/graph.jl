################################################################################

struct NodeID
	id::String

	NodeID(id) = new(valid_id(id))
end
Base.show(io::IO, id::NodeID) = print(io, id.id)
Base.escape_string(id::NodeID) = escape_string(id.id)
Base.:*(id::NodeID, t::AbstractString) = id.id*t

function valid_id(id::String)
	valid_char(c) = islowercase(c) | (c == '_') | isdigit(c)
	islowercase(id[1]) || error("First character in Node ID needs to be lower case character.")
	all(valid_char, id) || error("Node ID can only contain lower case letters, digits and underscores.")
	return id
end


################################################################################

abstract type GraphNode end

################################################################################

struct StartNode <: GraphNode
	id::NodeID
	text::String
	next::NodeID

	StartNode(;id, text, next) = new(NodeID(id), text, NodeID(next))
end
children(n::StartNode) = [n.next]

struct EndNode <: GraphNode
	id::NodeID
	text::String

	EndNode(;id, text="End of Action") = new(NodeID(id), text)
end
children(n::EndNode) = []

struct DummyNode <: GraphNode
	id::NodeID
	next::NodeID

	DummyNode(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::DummyNode) = [n.next]


################################################################################

struct JumpToGraph <: GraphNode
	id::NodeID
	text::String
	next::NodeID
	jump_graph::NodeID

	JumpToGraph(;id, text, next, jump_graph) =
		new(NodeID(id), text, NodeID(next), NodeID(jump_graph))
end
children(n::JumpToGraph) = [n.next]

struct ReturnFromGraph <: GraphNode
	id::NodeID
	jump_text::String

	ReturnFromGraph(;id, jump_text="Continue from where\nyou jumped to this\n graph.") = new(NodeID(id), jump_text)
end
children(n::ReturnFromGraph) = []


################################################################################

struct PerformAction <: GraphNode
	id::NodeID
	action::String
	next::NodeID

	PerformAction(;id, action, next) =
		new(NodeID(id), action, NodeID(next))
end
children(n::PerformAction) = [n.next]

struct BinaryCondition <: GraphNode
	id::NodeID
	condition::String
	next_true::NodeID
	next_false::NodeID

	BinaryCondition(;id, condition, next_true, next_false) =
		new(NodeID(id), condition, NodeID(next_true), NodeID(next_false))
end
children(n::BinaryCondition) = [n.next_true, n.next_false]

struct MultipleChoice <: GraphNode
	id::NodeID
	conditions::String
	nexts::Vector{NodeID}

	MultipleChoice(;id, conditions, nexts) =
		new(NodeID(id), conditions, NodeID.(nexts))
end
children(n::MultipleChoice) = n.nexts


################################################################################

struct SetStrategy <: GraphNode
	id::NodeID
	strategy::Strategy.Choice
	next::NodeID

	SetStrategy(;id, strategy, next) = new(NodeID(id), StrategyChoice(strategy), NodeID(next))
end
children(n::SetStrategy) = [n.next]

struct CheckStrategy <: GraphNode
	id::NodeID
	strategy::Strategy.Choice
	next_true::NodeID
	next_false::NodeID

	CheckStrategy(;id, strategy, next_true, next_false) =
	new(NodeID(id), StrategyChoice(strategy), NodeID(next_true), NodeID(next_false))
end
children(n::CheckStrategy) = [n.next_true, n.next_false]

################################################################################

struct RollActionDice <: GraphNode
	id::NodeID
	next::NodeID

	RollActionDice(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::RollActionDice) = [n.next]

struct AvailableModifiers <: GraphNode
	id::NodeID
	next::NodeID

	AvailableModifiers(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::AvailableModifiers) = [n.next]

struct SetActiveDie <: GraphNode
	id::NodeID
	next::NodeID
	next_no_die::NodeID

	die::Die.Face
	may_use_ring::Bool

	SetActiveDie(;id, next, next_no_die, die, may_use_ring=false) =
		new(NodeID(id), NodeID(next), NodeID(next_no_die), DieFace(die), may_use_ring)
end
children(n::SetActiveDie) = [n.next, n.next_no_die]

struct UseActiveDie <: GraphNode
	id::NodeID
	next::NodeID

	UseActiveDie(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::UseActiveDie) = [n.next]

struct SetRandomDie <: GraphNode
	id::NodeID
	next::NodeID

	SetRandomDie(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::SetRandomDie) = [n.next]

################################################################################

struct QuellerGraph
	root_node::NodeID
	nodes::Dict{NodeID,GraphNode}
	source_file::String
end

function unique_node_ids(nodes)
	conflicts = not_unique(nodes)
	return isempty(conflicts), getfield.(conflicts, :id)
end

function all_children_exists(nodes)
	child_ids = mapreduce(children, vcat, nodes)
	ids = getfield.(nodes, :id)
	id_not_exists(id) = !(id in ids)
	conflicts = filter(id_not_exists, child_ids)
	return isempty(conflicts), conflicts
end

function unique_root_ids(graphs)
	conflicts = not_unique(graphs, (g,j) -> (g.root_node == j.root_node))
	return isempty(conflicts), map(g -> g.root_node*" : "*g.source_file, conflicts)
end

function all_jump_points_exists(graphs)
	function get_jump_points(g)
		nodes = collect(values(g.nodes))
		jump_nodes = filter(n -> isa(n, JumpToGraph), nodes)
		return tuple.(getfield.(jump_nodes, :jump_graph),[ g.source_file])
	end

	jump_points = mapreduce(get_jump_points, vcat, graphs)
	root_nodes = getfield.(graphs, :root_node)
	jump_not_exists(j) = !(j[1] in root_nodes)
	conflicts = filter(jump_not_exists, jump_points)

	return isempty(conflicts), map(c -> c[1]*" : "*c[2], conflicts)
end

function get_graphs_not_jumped_to(graphs)
	function get_jump_points(g)
		nodes = collect(values(g.nodes))
		jump_nodes = filter(n -> isa(n, JumpToGraph), nodes)
		return getfield.(jump_nodes, :jump_graph)
	end
	jump_points = mapreduce(get_jump_points, vcat, graphs)
	root_not_jumped_to(g) = !(g.root_node in jump_points)
	unjumped = filter(root_not_jumped_to, collect(graphs))
	return map(g -> g.root_node*" : "*g.source_file, unjumped)
end

function load_graphs(file)
	nodes = include(file)

	unique, conflicts = unique_node_ids(nodes)
	!unique && error("Error loading nodes from file $(file). Not all ids are unique. Conflicting ids:\n$(strvec2str(conflicts))")

	all_exists, conflicts = all_children_exists(nodes)
	!all_exists && error("Error loading nodes from file $(file). Not all child nodes exists. Non-existing child ids:\n$(strvec2str(conflicts))")

	nodes_d = Dict(n.id => n for n in nodes)

	start_nodes = filter(n -> isa(n, StartNode), nodes)
	return [QuellerGraph(start.id, nodes_d, file) for start in start_nodes]
end

function load_graphs(files...)
	graphs = mapreduce(load_graphs, vcat, files)

	unique, conflicts = unique_root_ids(graphs)
	!unique && error("Error loading graphs, not all root node ids are unique. Conflictings graphs:\n$(strvec2str(conflicts))")

	jumps_exists, conflicts = all_jump_points_exists(graphs)
	!jumps_exists && @warn ("Warning, not all jumps exists. Non-existing jumps:\n$(strvec2str(conflicts))")

	return Dict(g.root_node => g for g in graphs)
end

