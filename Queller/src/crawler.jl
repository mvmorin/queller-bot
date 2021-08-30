################################################################################

struct ActiveDie
	die::Die.Face
	use_as::Die.Face
	use_modt::Bool
	use_ring::Bool

	used::Bool
end

ActiveDie(die, use_as, use_modt, use_ring) = ActiveDie(die, use_as, use_modt, use_ring, false)

use_active_die(d) = ActiveDie(d.die, d.use_as, d.use_modt, d.use_ring, true)

function Base.string(d::ActiveDie)
	d.die == d.use_as && return string(d.die)

	text = "$(string(d.die)) as $(string(d.use_as))"
	use_modt && return text*" by using the Messenger of the Dark Tower ability"
	use_ring && return text*" by using an Elven Ring"
	return text
end

function get_active_die(die, available_dice, may_use_modt, may_use_ring, discardable_dice)
	die in available_dice && return ActiveDie(die,die,false,false)

	(Die.ArmyMuster in available_dice) && (die == Die.Army || die == Die.Muster) && return ActiveDie(Die.ArmyMuster,die,false,false)
	(Die.Muster in available_dice) && (die == Die.Army && may_use_modt) && return ActiveDie(Die.Muster,die,true,false)

	discardable_dice = intersect(available_dice, discardable_dice)
	may_use_ring && !isempty(discardable_dice) && return ActiveDie(rand(discardable_dice),die,false,true)

	return nothing
end

################################################################################

mutable struct GraphCrawler
	current::Node
	jump_stack::Vector{Node}

	graphs::Dict{String,QuellerGraph}

	strategy::Strategy.Choice

	active_die::Union{ActiveDie,Nothing}
	available_dice::Vector{Die.Face}

	ring_available::Bool
	modt_available::Bool

	msg_buf::String

	function GraphCrawler(startgraph::String, graphs, strategy, available_dice; ring_available=false, modt_available=false)
		current = root(graphs[startgraph])

		jump_stack = Vector{Node}()
		sizehint!(jump_stack, 10)

		active_die = nothing

		msg_buf = ""

		gc = new(current,jump_stack,graphs,strategy,active_die,available_dice,ring_available,modt_available,msg_buf)

		autocrawl!(gc)
		return gc
	end
end

function autocrawl!(gc)
	# crawls the graph until it encounters node that requires interaction
	# store all node messages in a buffer

	!isempty(gc.msg_buf) && return # A step have already been taken

	interactive_node = Union{PerformAction,BinaryCondition,MultipleChoice}

	while !at_end(gc)
		gc.msg_buf = add2msgbuf(gc.msg_buf, gc.current)
		gc.current isa interactive_node && break
		gc.current = autonext!(gc, gc.current)
	end
end

function autonext!(gc, node::Union{Start,Dummy})
	# sets the current node to the next node, these nodes have no choices and do
	# not change the graph that is parsed.

	return getnext(node,nothing)
end

function autonext!(gc, node::JumpToGraph)
	# sets the current node to the start node of the graph that is jumped to

	push!(gc.jump_stack, node)
	return root(gc.graphs[node.jump_graph])
end

function autonext!(gc, ::ReturnFromGraph, _)
	# set the current node to the node after the JumpToGraph node from which the
	# jump was made

	node = pop!(gc.jump_stack)
	return getnext(node,nothing)
end

function autonext!(gc, node::CheckStrategy, graph)
	return getnext(node,CMD.Option(gc.strategy))
end

function autonext!(gc, node::SetActiveDie)
	!isnothing(gc.active_die) && gc.active_die.used && error("Trying to set an active die when a die already have been used.")

	gc.strategy == Strategy.Military && (discardable_dice = [Die.Character, Die.Event])
	gc.strategy == Strategy.Corruption && (discardable_dice = [Die.Army, Die.Muster, Die.ArmyMuster, Die.Event])

	active_die = get_active_die(node.die, gc.available_dice, gc.modt_available, gc.ring_available && node.may_use_ring, discardable_dice)
	if isnothing(active_die)
		return getnext(node,CMD.False())
	else
		gc.active_die = active_die
		return getnext(node,CMD.True())
	end
end

function autonext!(gc, node::UseActiveDie, graph)
	isnothing(gc.active_die) && error("No active die have been set before it is used.")

	gc.active_die = use_active_die(gc.active_die)
	return getnext(node,nothing)
end


################################################################################

function add2msgbuf(buf,node,debug=false)
	return buf*"\n"*getmsg(node)
end



################################################################################

at_end(gc) = gc.current isa End
getinteraction(gc) = (gc.msg_buf, getopt(gc.current))
die_used(gc) = gc.active_die.used ? gc.active_die.use_as : nothing

function proceed!(gc, opt)
	gc.current = getnext(gc.current,opt)
	gc.msg_buf = ""
	autocrawl!(gc)
end
