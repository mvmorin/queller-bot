################################################################################

mutable struct GraphCrawler
	current::Node
	jump_stack::Vector{Node}
	graphs::Dict{String,QuellerGraph}

	queller::QuellerState

	msg_buf::String

	function GraphCrawler(startgraph::String, graphs, queller)
		current = root(graphs[startgraph])

		jump_stack = Vector{Node}()
		sizehint!(jump_stack, 10)

		active_die = nothing

		msg_buf = ""

		gc = new(current,jump_stack,graphs,queller,msg_buf)

		autocrawl!(gc)
		return gc
	end
end

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

function add2msgbuf(buf,node,queller,debug=false)
	if node isa StateInteractionNode
		return buf*"\n"*getmsg(node,queller)
	else
		return buf*"\n"*getmsg(node)
	end
end


################################################################################

at_end(gc) = gc.current isa End
getinteraction(gc) = (gc.msg_buf, getopt(gc.current))
die_used(gc) = gc.active_die.used ? gc.active_die.use_as : nothing

function proceed!(gc, opt)
	gc.current = gc.current isa GetAvailableDice ?
		getnext!(gc.current, gc.queller, opt) : getnext(gc.current, opt)
	gc.msg_buf = ""
	autocrawl!(gc)
end

