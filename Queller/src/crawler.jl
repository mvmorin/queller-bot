################################################################################

struct CrawlerNodePointer
	node::NodeID
	graph::NodeID
end

mutable struct GraphCrawler
	current
	jump_stack
	graphs

	strategy

	active_die
	available_dice

	ring_available
	modt_available

end
