################################################################################

struct NodeID
	id::String

	NodeID(id) = new(valid_id(id))
end
Base.show(io::IO, id::NodeID) = print(io, id.id)
Base.escape_string(id::NodeID) = escape_string(id.id)
Base.:*(id::NodeID, t::AbstractString) = id.id*t
Base.convert(::Type{NodeID},s::AbstractString) = NodeID(s)

function valid_id(id::AbstractString)
	valid_char(c) = islowercase(c) | (c == '_') | isdigit(c)
	islowercase(id[1]) || error("First character in Node ID needs to be lower case character.")
	all(valid_char, id) || error("Node ID can only contain lower case letters, digits and underscores.")
	return id
end



################################################################################

abstract type QuellerNode end

children(n::QuellerNode) = error("Not implemented.")
getopt(n::QuellerNode) = error("Not implemented.") # returns nothing if no interaction is necessary, otherwise it returns a vector of CMD.InputCommands that getnext accept
getnext(n::QuellerNode, opt) = error("Not implemented.")
Base.string(n::QuellerNode) = error("Not implemented.")



################################################################################

struct StartNode <: QuellerNode
	id::NodeID
	text::String
	next::NodeID

	StartNode(;id, text, next) = new(NodeID(id), strip(text), NodeID(next))
end
children(n::StartNode) = [n.next]
getopt(n::StartNode) = nothing
getnext(n::StartNode, opt::Nothing) = n.next
Base.string(n::StartNode) = n.text


struct EndNode <: QuellerNode
	id::NodeID
	text::String

	EndNode(;id, text="End of Action") = new(NodeID(id), strip(text))
end
children(n::EndNode) = []
getopt(n::EndNode) = nothing
getnext(n::EndNode, opt::Nothing) = nothing
Base.string(n::EndNode) = n.text


struct DummyNode <: QuellerNode
	id::NodeID
	next::NodeID

	DummyNode(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::DummyNode) = [n.next]
getopt(n::DummyNode) = nothing
getnext(n::DummyNode, opt::Nothing) = n.next
Base.string(n::DummyNode) = ""



################################################################################

struct JumpToGraph <: QuellerNode
	id::NodeID
	text::String
	next::NodeID
	jump_graph::NodeID

	JumpToGraph(;id, text, next, jump_graph) =
		new(NodeID(id), strip(text), NodeID(next), NodeID(jump_graph))
end
children(n::JumpToGraph) = [n.next]
getopt(n::JumpToGraph) = nothing
getnext(n::JumpToGraph, opt::Nothing) = n.next
Base.string(n::JumpToGraph) = n.text


struct ReturnFromGraph <: QuellerNode
	id::NodeID
	jump_text::String

	ReturnFromGraph(;id, jump_text="Continue from where\nyou jumped to this\n graph.") = new(NodeID(id), strip(jump_text))
end
children(n::ReturnFromGraph) = []
getopt(n::ReturnFromGraph) = nothing
getnext(n::ReturnFromGraph, opt::Nothing) = nothing
Base.string(n::ReturnFromGraph) = n.jump_text



################################################################################

struct PerformAction <: QuellerNode
	id::NodeID
	action::String
	next::NodeID

	PerformAction(;id, action, next) =
		new(NodeID(id), strip(action), NodeID(next))
end
children(n::PerformAction) = [n.next]
getopt(n::PerformAction) = [CMD.Blank()]
getnext(n::PerformAction, opt) = n.next
Base.string(n::PerformAction) = n.action


struct BinaryCondition <: QuellerNode
	id::NodeID
	condition::String
	next_true::NodeID
	next_false::NodeID

	BinaryCondition(;id, condition, next_true, next_false) =
		new(NodeID(id), strip(condition), NodeID(next_true), NodeID(next_false))
end
children(n::BinaryCondition) = [n.next_true, n.next_false]
getopt(n::BinaryCondition) = [CMD.True(), CMD.False()]
getnext(n::BinaryCondition, opt::CMD.True) = n.next_true
getnext(n::BinaryCondition, opt::CMD.False) = n.next_false
Base.string(n::BinaryCondition) = n.condition


struct MultipleChoice <: QuellerNode
	id::NodeID
	conditions::String
	nexts::Vector{NodeID}

	MultipleChoice(;id, conditions, nexts) =
		new(NodeID(id), strip(conditions), NodeID.(nexts))
end
children(n::MultipleChoice) = n.nexts
getopt(n::MultipleChoice) = CMD.Option.(1:length(n.nexts))
getnext(n::MultipleChoice, opt::CMD.Option) = n.nexts[opt.opt]
Base.string(n::MultipleChoice) = n.conditions



################################################################################

struct CheckStrategy <: QuellerNode
	id::NodeID
	strategy::Strategy.Choice
	next_true::NodeID
	next_false::NodeID

	CheckStrategy(;id, strategy, next_true, next_false) =
	new(NodeID(id), StrategyChoice(strategy), NodeID(next_true), NodeID(next_false))
end
children(n::CheckStrategy) = [n.next_true, n.next_false]
getopt(n::CheckStrategy) = CMD.Option.(instances(Strategy.Choice))
getnext(n::CheckStrategy, opt::CMD.Option) = (opt.opt == n.strategy ? n.next_true : n.next_false)
Base.string(n::CheckStrategy) = "The $(string(n.strategy)) strategy is used."


struct SetActiveDie <: QuellerNode
	id::NodeID
	next::NodeID
	next_no_die::NodeID

	die::Die.Face
	may_use_ring::Bool

	SetActiveDie(;id, next, next_no_die, die, may_use_ring=false) =
		new(NodeID(id), NodeID(next), NodeID(next_no_die), DieFace(die), may_use_ring)
end
children(n::SetActiveDie) = [n.next, n.next_no_die]
getopt(n::SetActiveDie) = [CMD.True(), CMD.False()]
getnext(n::SetActiveDie, opt::CMD.True) = n.next
getnext(n::SetActiveDie, opt::CMD.False) = n.next_no_die
function Base.string(n::SetActiveDie)
	prio_list = [string(n.die)]
	if n.die == Die.Army
		push!(prio_list, "$(string(Die.ArmyMuster)) as $(string(Die.Army))")
		push!(prio_list, "$(string(Die.Muster)) and Messenger of the Dark Tower as $(string(Die.Army))")
	elseif n.die == Die.Muster
		push!(prio_list, "$(string(Die.ArmyMuster)) as a $(string(Die.Muster))")
	end

	if n.may_use_ring
		push!(prio_list, "A random non-*preferred* die and an Elven Ring as $(string(n.die))")
	end


	text = """
	Set the first matching die as the Active Die:

	"""
	for (i, d) in enumerate(prio_list)
		text *= "$(i). $(d)\n"
	end
	return text
end


struct UseActiveDie <: QuellerNode
	id::NodeID
	next::NodeID

	UseActiveDie(;id, next) = new(NodeID(id), NodeID(next))
end
children(n::UseActiveDie) = [n.next]
getopt(n::UseActiveDie) = nothing
getnext(n::UseActiveDie, opt::Nothing) = n.next
Base.string(n::UseActiveDie) = "Use the Active Die to:"



################################################################################

struct QuellerGraph
	root_node::NodeID
	nodes::Dict{NodeID,QuellerNode}
	source_file::String
end

Base.getindex(g::QuellerGraph,n::AbstractString) = g[NodeID(n)]
Base.getindex(g::QuellerGraph,n::NodeID) = g.nodes[n]


################################################################################

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
	!jumps_exists && error("Warning, not all jumps exists. Non-existing jumps:\n$(strvec2str(conflicts))")

	return Dict(g.root_node => g for g in graphs)
end

################################################################################

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

