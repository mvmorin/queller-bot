################################################################################

mutable struct GraphCrawler
	current::Node
	jump_stack::Vector{Node}
	graphs::Dict{String,QuellerGraph}

	queller::QuellerState

	msg_buf::String

	function GraphCrawler(startgraph::String, graphs, available_dice)
		current = root(graphs[startgraph])

		jump_stack = Vector{Node}()
		sizehint!(jump_stack, 10)

		active_die = nothing

		msg_buf = ""

		queller = QuellerState(available_dice)

		gc = new(current,jump_stack,graphs,queller,msg_buf)

		autocrawl!(gc)
		return gc
	end
end


################################################################################

function autocrawl!(gc)
	# crawls the graph until it encounters node that requires interaction
	# store all node messages in a buffer

	!isempty(gc.msg_buf) && return # A step have already been taken

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
at_end(gc) = gc.current isa End
getinteraction(gc) = (gc.msg_buf, getopt(gc.current))

function proceed!(gc, opt)
	gc.current = gc.current isa GetAvailableDice ?
		getnext!(gc.current, gc.queller, opt) : getnext(gc.current, opt)
	gc.msg_buf = ""
	autocrawl!(gc)
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

