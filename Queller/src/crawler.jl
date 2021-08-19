################################################################################

struct NodeAndGraph
	node::NodeID
	graph::NodeID
end

const NaG = NodeAndGraph

mutable struct GraphCrawler
	current::NodeAndGraph
	jump_stack::Vector{NodeAndGraph}
	graphs::Dict{NodeID,QuellerGraph}

	strategy::Strategy.Choice

	active_die::Union{Die.Face,Nothing}
	available_dice::Vector{Die.Face}

	ring_available::Bool
	modt_available::Bool

	function GraphCrawler(startgraph,graphs,strategy,available_dice;ring_available=false,modt_available=false)
		current = NaG(startgraph, startgraph)
		jump_stack = Vector{NaG}()
		active_die = nothing

		new(current,jump_stack,graphs,strategy,active_die,available_dice,ring_available,modt_available)
	end
end
