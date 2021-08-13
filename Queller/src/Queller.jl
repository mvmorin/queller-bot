module Queller

export load_graphs,
	check_queller_graphs


################################################################################
not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)

strvec2str(v) = mapreduce(s -> s*'\n', *, v)

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

struct DummyNode <: GraphNode
	id::String
	next::String

	DummyNode(;id, next) = new(valid_id(id), valid_id(next))
end
children(n::DummyNode) = [n.next]


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
	# 'W' => "Will of the West", # Never used
	)
function valid_die(c)
	c in keys(DICE) || error("\'$(c)\' is not a valid die.")
	return c
end


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
		new(valid_id(id), valid_id(next), valid_id(next_no_die), valid_die(die), may_use_ring)
end
children(n::SetActiveDie) = [n.next, n.next_no_die]

struct UseActiveDie <: GraphNode
	id::String
	next::String

	UseActiveDie(;id, next) = new(valid_id(id), valid_id(next))
end
children(n::UseActiveDie) = [n.next]

struct SetRandomDie <: GraphNode
	id::String
	next::String

	SetRandomDie(;id, next) = new(valid_id(id), valid_id(next))
end
children(n::SetRandomDie) = [n.next]


################################################################################

struct QuellerGraph
	root_node::String
	nodes::Dict{String,GraphNode}
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

################################################################################

include("graphviz.jl")

################################################################################

pkg_dir = abspath(joinpath(dirname(pathof(@__MODULE__)),".."))

graph_sources = [
	"$(pkg_dir)/graphs/phase-1.jl"
	"$(pkg_dir)/graphs/phase-2.jl"
	"$(pkg_dir)/graphs/phase-3.jl"
	"$(pkg_dir)/graphs/phase-4.jl"
	"$(pkg_dir)/graphs/select-action-corr.jl"
	"$(pkg_dir)/graphs/select-action-mili.jl"
	"$(pkg_dir)/graphs/threat-exposed.jl"
	"$(pkg_dir)/graphs/battle.jl"
	"$(pkg_dir)/graphs/character.jl"
	"$(pkg_dir)/graphs/event-cards.jl"
	"$(pkg_dir)/graphs/movement-attack.jl"
	"$(pkg_dir)/graphs/muster.jl"
	]



function check_queller_graphs()
	graph_output(f) = joinpath(pkg_dir, "graph_output", basename(f)*".ps")
	for f in graph_sources
		graph2ps(f, graph_output(f))
	end
	println("All graphs in PostScript can be found in Queller/graph_output")

	graphs = load_graphs(graph_sources...)

	unjumped = get_graphs_not_jumped_to(values(graphs))
	println("Graphs that are not jumped to from another graph:\n$(strvec2str(unjumped))")
end





end
