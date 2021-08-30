abstract type Node end

setid!(n::Node, id::Symbol) = setid!(n, valid_id(string(id)))
setid!(n::Node, id::String) = error("Not implemented!")
getid(n::Node) = error("Not implemented!")

getopt(n::Node) = error("Not implemented!")
getnext(n::Node, opt) = error("Not implemented!")

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

################################################################################

mutable struct Start <: Node
	id::String
	text::String
	next::Node

	Start(text) = (obj = new(); obj.text = strip(text); obj)
end
setid!(n::Start, id::String) = (n.id = id)
getid(n::Start) = n.id

getopt(n::Start) = nothing
getnext(n::Start, opt::Nothing) = n.next
setnext!(n::Start, next::Node) = (n.next = next)

getmsg(n::Start) = n.text


mutable struct End <: Node
	id::String
	text::String

	End(text="End of Action") = (obj = new(); obj.text = strip(text); obj)
end
setid!(n::End, id::String) = (n.id = id)
getid(n::End) = n.id

getopt(n::End) = nothing
getnext(n::End, opt::Nothing) = nothing

getmsg(n::End) = n.text


mutable struct Dummy <: Node
	id::String
	next::Node

	Dummy() = new()
end
setid!(n::Dummy, id::String) = (n.id = id)
getid(n::Dummy) = n.id

getopt(n::Dummy) = nothing
getnext(n::Dummy, opt::Nothing) = n.next
setnext!(n::Dummy, next::Node) = (n.next = next)

getmsg(n::Dummy) = ""



################################################################################

mutable struct JumpToGraph <: Node
	id::String
	text::String
	next::Node
	jump_graph::String

	JumpToGraph(text,jump_graph) = (obj = new(); obj.text = strip(text); obj.jump_graph = jump_graph; obj)
end
setid!(n::JumpToGraph, id::String) = (n.id = id)
getid(n::JumpToGraph) = n.id

getopt(n::JumpToGraph) = nothing
getnext(n::JumpToGraph, opt::Nothing) = n.next
setnext!(n::JumpToGraph, next::Node) = (n.next = next)

getmsg(n::JumpToGraph) = n.text


mutable struct ReturnFromGraph <: Node
	id::String
	jump_text::String

	ReturnFromGraph(jump_text="Continue from where\nyou jumped to this\n graph.") = (obj = new(); obj.jump_text = strip(jump_text); obj)
end
setid!(n::ReturnFromGraph, id::String) = (n.id = id)
getid(n::ReturnFromGraph) = n.id

getopt(n::ReturnFromGraph) = nothing
getnext(n::ReturnFromGraph, opt::Nothing) = nothing

getmsg(n::ReturnFromGraph) = n.jump_text



################################################################################

mutable struct PerformAction <: Node
	id::String
	action::String
	next::Node

	PerformAction(action="Continue from where\nyou jumped to this\n graph.") = (obj = new(); obj.action = strip(action); obj)
end
setid!(n::PerformAction, id::String) = (n.id = id)
getid(n::PerformAction) = n.id

getopt(n::PerformAction) = [CMD.Blank()]
getnext(n::PerformAction, opt) = n.next
setnext!(n::PerformAction, next::Node) = (n.next = next)

getmsg(n::PerformAction) = n.action


mutable struct BinaryCondition <: Node
	id::String
	condition::String
	n_true::Node
	n_false::Node

	BinaryCondition(condition) = (obj = new(); obj.condition = strip(condition); obj)
end
setid!(n::BinaryCondition, id::String) = (n.id = id)
getid(n::BinaryCondition) = n.id

getopt(n::BinaryCondition) = [CMD.True(), CMD.False()]
getnext(n::BinaryCondition, opt::CMD.True) = n.n_true
getnext(n::BinaryCondition, opt::CMD.False) = n.n_false
setnext!(n::BinaryCondition, name::Symbol,next::Node) = setfield!(n,name,next)

getmsg(n::BinaryCondition) = n.condition


mutable struct MultipleChoice <: Node
	id::String
	conditions::String
	nexts::Vector{<:Node}

	MultipleChoice(conditions) = (obj = new(); obj.conditions = strip(conditions); obj)
end
setid!(n::MultipleChoice, id::String) = (n.id = id)
getid(n::MultipleChoice) = n.id

getopt(n::MultipleChoice) = CMD.Option.(1:length(n.nexts))
getnext(n::MultipleChoice, opt::CMD.Option) = n.nexts[opt.opt]
setnext!(n::MultipleChoice, nexts::Vector{<:Node}) = (n.nexts = nexts)

getmsg(n::MultipleChoice) = n.conditions



################################################################################

mutable struct CheckStrategy <: Node
	id::String
	strategy::Strategy.Choice
	n_true::Node
	n_false::Node

	CheckStrategy(strategy) = (obj = new(); obj.strategy = StrategyChoice(strategy); obj)
end
setid!(n::CheckStrategy, id::String) = (n.id = id)
getid(n::CheckStrategy) = n.id

getopt(n::CheckStrategy) = CMD.Option.(instances(Strategy.Choice))
getnext(n::CheckStrategy, opt::CMD.Option) = (opt.opt == n.strategy ? n.n_true : n.n_false)
setnext!(n::CheckStrategy, name::Symbol, next::Node) = setfield!(n,name,next)

getmsg(n::CheckStrategy) = "The $(string(n.strategy)) strategy is used."


mutable struct SetActiveDie <: Node
	id::String
	next::Node
	no_die::Node

	die::Die.Face
	may_use_ring::Bool

	SetActiveDie(die; may_use_ring=false) = (obj = new(); obj.die = DieFace(die); obj.may_use_ring = may_use_ring; obj)
end
setid!(n::SetActiveDie, id::String) = (n.id = id)
getid(n::SetActiveDie) = n.id

getopt(n::SetActiveDie) = [CMD.True(), CMD.False()]
getnext(n::SetActiveDie, opt::CMD.True) = n.next
getnext(n::SetActiveDie, opt::CMD.False) = n.no_die
setnext!(n::SetActiveDie, name::Symbol, next::Node) = setfield!(n,name,next)

function getmsg(n::SetActiveDie)
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


mutable struct UseActiveDie <: Node
	id::String
	next::Node

	UseActiveDie() = new()
end
setid!(n::UseActiveDie, id::String) = (n.id = id)
getid(n::UseActiveDie) = n.id

getopt(n::UseActiveDie) = nothing
getnext(n::UseActiveDie, opt::Nothing) = n.next
setnext!(n::UseActiveDie, next::Node) = (n.next = next)

getmsg(n::UseActiveDie) = "Use the Active Die to:"




################################################################################
fieldsdefined(obj) = all(i -> isdefined(obj,i), 1:nfields(obj))

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
