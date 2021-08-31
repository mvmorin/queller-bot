abstract type Node end

setid!(n::Node, id::Symbol) = setid!(n, valid_id(string(id)))
setid!(n::Node, id::String) = (n.id = id)
getid(n::Node) = n.id

setnext!(n::Node, next::Node) = error("'$(getid(n)) = $(typeof(n))(...) -> next' not implemented for $(typeof(n))")
setnext!(n::Node, nexts::Vector{<:Node}) = error("'$(getid(n)) = $(typeof(n))(...) -> [next_1, ..., next_n]' not implemented for $(typeof(n))")
setnext!(n::Node, name::Symbol, next::Node) = error("'$(getid(n)) = $(typeof(n))(...) -> [next_kw = next, ...]' not implemented for $(typeof(n))")

getmsg(n::Node) = error("Not implemented!")

function valid_id(id::AbstractString)
	valid_char(c) = islowercase(c) | (c == '_') | isdigit(c)
	islowercase(id[1]) || error("First character in Node ID needs to be lower case character.")
	all(valid_char, id) || error("Node ID can only contain lower case letters, digits and underscores.")
	return id
end

abstract type NonInteractiveNode <: Node end
getnext(n::NonInteractiveNode) = error("Not implemented!")

abstract type InteractiveNode <: Node end
getopt(n::InteractiveNode) = error("Not implemented!")
getnext(n::InteractiveNode, opt) = error("Not implemented!")

abstract type StateInteractionNode <: Node end
getnext!(n::StateInteractionNode, state) = error("Not implemented!")
getmsg(n::StateInteractionNode, state) = getmsg(n)


################################################################################

mutable struct Start <: NonInteractiveNode
	id::String
	next::Node

	Start() = new()
end
getnext(n::Start) = n.next
setnext!(n::Start, next::Node) = (n.next = next)
getmsg(n::Start) = n.id


mutable struct End <: NonInteractiveNode
	id::String
	text::String

	End(text="End of Action") = (obj = new(); obj.text = strip(text); obj)
end
getnext(n::End) = error("$(typeof(n)) have no children.")
getmsg(n::End) = n.text


mutable struct Dummy <: NonInteractiveNode
	id::String
	next::Node

	Dummy() = new()
end
getnext(n::Dummy) = n.next
setnext!(n::Dummy, next::Node) = (n.next = next)
getmsg(n::Dummy) = "Dummy: $(getid(n))"



################################################################################

mutable struct JumpToGraph <: NonInteractiveNode
	id::String
	next::Node
	jump_graph::String

	JumpToGraph(jump_graph) = (obj = new(); obj.jump_graph = jump_graph; obj)
end
getnext(n::JumpToGraph) = n.next
setnext!(n::JumpToGraph, next::Node) = (n.next = next)
getmsg(n::JumpToGraph) = "Jump to: $(n.jump_graph)"


mutable struct ReturnFromGraph <: NonInteractiveNode
	id::String

	ReturnFromGraph() = new()
end
getnext(n::ReturnFromGraph) = error("$(typeof(n)) have no children.")
getmsg(n::ReturnFromGraph) = "Continue from where\nyou jumped to this\n graph."



################################################################################

mutable struct PerformAction <: InteractiveNode
	id::String
	action::String
	next::Node

	PerformAction(action="Continue from where\nyou jumped to this\n graph.") = (obj = new(); obj.action = strip(action); obj)
end
getopt(n::PerformAction) = [CMD.Blank()]
getnext(n::PerformAction, opt::CMD.Blank) = n.next
setnext!(n::PerformAction, next::Node) = (n.next = next)
getmsg(n::PerformAction) = n.action


mutable struct BinaryCondition <: InteractiveNode
	id::String
	condition::String
	n_true::Node
	n_false::Node

	BinaryCondition(condition) = (obj = new(); obj.condition = strip(condition); obj)
end
getopt(n::BinaryCondition) = [CMD.True(), CMD.False()]
getnext(n::BinaryCondition, opt::CMD.True) = n.n_true
getnext(n::BinaryCondition, opt::CMD.False) = n.n_false
setnext!(n::BinaryCondition, name::Symbol,next::Node) = setfield!(n,name,next)
getmsg(n::BinaryCondition) = n.condition


mutable struct MultipleChoice <: InteractiveNode
	id::String
	conditions::String
	nexts::Vector{<:Node}

	MultipleChoice(conditions) = (obj = new(); obj.conditions = strip(conditions); obj)
end
getopt(n::MultipleChoice) = CMD.Option.(1:length(n.nexts))
getnext(n::MultipleChoice, opt::CMD.Option) = n.nexts[opt.opt]
setnext!(n::MultipleChoice, nexts::Vector{<:Node}) = (n.nexts = nexts)
getmsg(n::MultipleChoice) = n.conditions


################################################################################

struct QuellerGraph
	root_node::Node
	nodes::Vector{<:Node}
	source_file::String
end

getid(g::QuellerGraph) = getid(root(g))
root(g::QuellerGraph) = g.root_node

function load_graphs_from_file(file)
	starts, nodes = include(file)
	return [QuellerGraph(start, nodes, file) for start in starts]
end

function load_graphs(files...)
	graphs = mapreduce(load_graphs_from_file, vcat, files)

	unique, conflicts = unique_root_ids(graphs)
	!unique && error("Error loading graphs, not all root node ids are unique. Conflictings graphs:\n$(strvec2str(conflicts))")

	jumps_exists, conflicts = all_jump_points_exists(graphs)
	!jumps_exists && error("Warning, not all jumps exists. Non-existing jumps:\n$(strvec2str(conflicts))")

	return Dict(getid(g) => g for g in graphs)
end

function unique_root_ids(graphs)
	conflicts = not_unique(graphs, (g,j) -> (getid(g) == getid(j)) )
	return isempty(conflicts), map(g -> getid(g)*" : "*g.source_file, conflicts)
end

function get_jump_points(g)
	jump_nodes = filter(n -> isa(n, JumpToGraph), g.nodes)
	return tuple.(getfield.(jump_nodes, :jump_graph),[ g.source_file])
end

function all_jump_points_exists(graphs)
	jump_points = mapreduce(get_jump_points, vcat, graphs)
	graph_ids = getid.(graphs)
	jump_not_exists(j) = !(j[1] in graph_ids)
	conflicts = filter(jump_not_exists, jump_points)
	return isempty(conflicts), map(c -> c[1]*" : "*c[2], conflicts)
end

function get_graphs_not_jumped_to(graphs)
	jump_points = getindex.(mapreduce(get_jump_points, vcat, graphs),1)
	graph_not_jumped_to(g) = !(getid(g) in jump_points)
	unjumped = filter(graph_not_jumped_to, collect(graphs))
	return map(g -> getid(g)*" : "*g.source_file, unjumped)
end


################################################################################

macro graphs(node_block)
	return quote
		__nodes = Dict{Symbol, Node}()

		__edges_single = Vector{Tuple{Node,Symbol}}()
		__edges_multi = Vector{Tuple{Node,Vector{Symbol}}}()
		__edges_named = Vector{Tuple{Node,Symbol,Symbol}}()

		$node_block

		try
			for (n,next) in __edges_single
				setnext!(n, __nodes[next])
			end
			for (n,nexts) in __edges_multi
				setnext!(n, [__nodes[next] for next in nexts])
			end
			for (n,name,next) in __edges_named
				setnext!(n, name, __nodes[next])
			end
		catch e
			e isa KeyError && error("Can't link to node '$(string(e.key))', node not found.")
			rethrow()
		end

		nodes = collect(values(__nodes))
		starts = filter(n -> n isa Start, nodes)

		undef_nodes = filter(!(fieldsdefined), nodes)
		for n in undef_nodes
			error("Not all edges set on node '$(getid(n))' (or it have another un-initialized field).")
		end

		(starts, nodes)
	end
end

macro node(exp)
	err_msg = """
	Invalid node format. Valid formats are:
		@node id = NodeType(...) -> []
		@node id = NodeType(...) -> next
		@node id = NodeType(...) -> [next_1, ..., next_n]
		@node id = NodeType(...) -> [next_kw = next, ...]
	"""
	exp.head != :(=) && error(err_msg)
	exp.args[2].head != :(->) && error(err_msg)

	id = exp.args[1]
	node = exp.args[2].args[1]
	next = exp.args[2].args[2].args[2]


	isa_vecexpr(e) = e isa Expr && e.head in [:vect, :hcat, :vcat]

	if next isa Symbol
		edge_push = :(push!(__edges_single, (n, $(Meta.quot(next)))))

	elseif isa_vecexpr(next) && isempty(next.args)
		edge_push = :()

	elseif isa_vecexpr(next) && all(a -> (a isa Symbol), next.args)
		next = [s for s in next.args]
		edge_push = :(push!(__edges_multi, (n, $(Meta.quot(next)))))

	elseif isa_vecexpr(next) && all(a -> a isa Expr, next.args) && all(a -> a.head == :(=), next.args)
		edge_push = :()
		for ass in next.args
			name = ass.args[1]
			next = ass.args[2]
			edge_push = :($edge_push; push!(__edges_named, (n, $(Meta.quot(name)), $(Meta.quot(next)))) )
		end

	else
		error(err_msg)
	end


	return quote
		id = $(Meta.quot(id))
		id in keys(__nodes) && error("Node '$(string(id))' already exists.")

		n = $node
		setid!(n,id)
		__nodes[id] = n

		$edge_push
	end
end
