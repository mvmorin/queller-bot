let
	graph = QuellerGraph(
		id = "phase_4_corr",
		text = "Phase 4: Corruption and Military Strategy",
		root_node = "p4_1",
		)

	PerformAction(graph,
		id = "p4_1",
		action = """
			Roll the remaining action dice.
			""",
		next_node = "p4_end",
		)

	EndNode(graph,
		id = "p4_end",
		text = "End of Phase",
		)

end
