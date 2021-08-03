let
	graph = QuellerGraph(
		id = "phase_2_mili",
		text = "Phase 2: Military Strategy",
		root_node = "p2_1",
		)

	YesNoCondition(graph,
		id = "p2_1",
		condition = """
			After the free peoples player have
			chosed whether to reveal, is the
			shadow victory points lower than
			the corruption points?
			""",
		next_node_yes = "p2_corr",
		next_node_no = "p2_end",
		)

	PerformAction(graph,
		id = "p2_corr",
		action = """
			Use the corruption strategy for the
			remaining phases of the turn.
			""",
		next_node = "p2_end",
		)

	EndNode(graph,
		id = "p2_end",
		text = "End of Phase",
		)
end
