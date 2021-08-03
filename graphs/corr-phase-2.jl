let
	graph = QuellerGraph(
		id = "phase_2_corr",
		text = "Phase 2: Corruption Strategy",
		root_node = "p2_1",
		)

	YesNoCondition(graph,
		id = "p2_1",
		condition = """
			After the free peoples player have
			chosed whether to reveal, is the
			corruption points lower than the
			shadow victory points?
			""",
		next_node_yes = "p2_mili",
		next_node_no = "p2_end",
		)

	PerformAction(graph,
		id = "p2_mili",
		action = """
			Use the military strategy for the
			remaining phases of the turn.
			""",
		next_node = "p2_end",
		)

	EndNode(graph,
		id = "p2_end",
		text = "End of Phase",
		)
end
