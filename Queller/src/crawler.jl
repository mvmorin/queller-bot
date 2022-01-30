################################################################################

mutable struct GraphCrawler
	root_node::Node
	available_dice::Vector{Die.Face}
	graphs::Dict{String,QuellerGraph}
	strategy::Strategy.Choice

	current::Node
	jump_stack::Vector{Node}

	options::Vector{CMD.Command}

	queller::QuellerState

	msg_buf::String

	function GraphCrawler(startgraph::String, graphs, available_dice, strategy)
		gc = new()

		gc.root_node = root(graphs[startgraph])
		gc.available_dice = available_dice
		gc.graphs = graphs
		gc.strategy = strategy

		return initialize!(gc)
	end
end

function initialize!(gc::GraphCrawler)
	gc.current = gc.root_node

	gc.jump_stack = Vector{Node}()
	sizehint!(gc.jump_stack, 10)

	gc.options = Vector{CMD.Command}()
	sizehint!(gc.options, 30)

	gc.queller = QuellerState(gc.strategy, deepcopy(gc.available_dice))

	gc.msg_buf = ""

	autocrawl!(gc)

	return gc
end


################################################################################

function autocrawl!(gc)
	# crawls the graph until it encounters node that requires interaction
	# store all node messages in a buffer

	gc.msg_buf = ""

	while !at_end(gc)
		gc.msg_buf = add2msgbuf(gc.msg_buf, gc.current, gc.queller)
		gc.current isa InteractiveNode && break
		gc.current = autonext!(gc, gc.current)
	end
end

autonext!(gc, node::NonInteractiveNode) = getnext(node)
autonext!(gc, node::StateInteractionNode) = getnext!(node,gc.queller)

function autonext!(gc, node::JumpToGraph)
	push!(gc.jump_stack, node)
	return root(gc.graphs[node.jump_graph])
end

function autonext!(gc, ::ReturnFromGraph)
	node = pop!(gc.jump_stack)
	return getnext(node)
end


################################################################################

get_available_dice(gc) = gc.queller.available_dice
get_strategy(gc) = gc.queller.strategy
at_end(gc) = gc.current isa End
getinteraction(gc) = (gc.msg_buf, getopt(gc.current))

function proceed!(gc, opt)
	push!(gc.options, opt)
	gc.current = gc.current isa GetAvailableDice ?
		getnext!(gc.current, gc.queller, opt) : getnext(gc.current, opt)
	autocrawl!(gc)
end

function undo!(gc)
	isempty(gc.options) && return false # nothing to undo

	# undo latest options
	options = gc.options
	pop!(options)

	# reset state and replay remaining options
	initialize!(gc)
	for opt in options
		proceed!(gc, opt)
	end

	return true
end



################################################################################

add2msgbuf(buf,node::UseActiveDie,queller) = buf*"\n"*getmsg(node,queller)*"\n"
add2msgbuf(buf,node::InteractiveNode,queller) = buf*"\n"*getmsg(node)
add2msgbuf(buf,node::Node,queller) = buf

function add2msgbuf(buf, node::Union{BinaryCondition,MultipleChoice}, queller)
	die = queller.active_die
	!isnothing(die) && (buf = buf*"\n"*"Using $(Die.article(die.use_as)) $(string(die.use_as)):\n")
	return buf*"\n"*getmsg(node)
end

