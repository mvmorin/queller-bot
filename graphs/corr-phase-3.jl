let
	graph = QuellerGraph(
		id = "phase_3_corr",
		text = "Phase 3: Corruption Strategy",
		root_node = "p3_1",
		)



	YesNoCondition(graph,
		id = "p3_1",
		condition = """
			Is the fellowship at the
			starting position and is
			its progress is 0?
			""",
		next_node_yes = "p3_1_yes",
		next_node_no = "p3_2",
		)
	PerformAction(graph,
		id = "p3_1_yes",
		action = """
			Roll a d6. On 4+, assign
			1 die to the hunt pool,
			otherwise do nothing.
			""",
		next_node = "p3_end",
		)



	YesNoCondition(graph,
		id = "p3_2",
		condition = """
			Is the fellowship on the
			mordor track?
			""",
		next_node_yes = "p3_2_yes",
		next_node_no = "p3_3",
		)
	PerformAction(graph,
		id = "p3_2_yes",
		action = """
			Assign the maximum allowed
			number of dice to the hunt
			pool.
			""",
		next_node = "p3_end",
		)



	YesNoCondition(graph,
		id = "p3_3",
		condition = """
			Is a *mobile* army adjecent
			to *target* which would the
			game if it attacked or does
			the shadow only has 7 dice?
			""",
		next_node_yes = "p3_3_yes",
		next_node_no = "p3_4",
		)
	PerformAction(graph,
		id = "p3_3_yes",
		action = """
			Assign 1 die to the hunt pool.
			""",
		next_node = "p3_end",
		)



	YesNoCondition(graph,
		id = "p3_4",
		condition = """
			Is the fellowships progress
			greater than 4?
			""",
		next_node_yes = "p3_4_yes",
		next_node_no = "p3_5",
		)
	PerformAction(graph,
		id = "p3_4_yes",
		action = """
			Assign 2 dice to the hunt pool.
			""",
		next_node = "p3_end",
		)



	YesNoCondition(graph,
		id = "p3_5",
		condition = """
			Does the shortest path to morder
			for the fellowship lead via a
			shadow stronghold and the progress
			allows them to pass it or be
			within 2 steps from it?
			""",
		next_node_yes = "p3_5_yes",
		next_node_no = "p3_5_no",
		)
	PerformAction(graph,
		id = "p3_5_yes",
		action = """
			Assign 2 dice to the hunt pool.
			""",
		next_node = "p3_end",
		)
	PerformAction(graph,
		id = "p3_5_no",
		action = """
			Assign 1 dice to the hunt pool.
			""",
		next_node = "p3_end",
		)


	EndNode(graph,
		id = "p3_end",
		text = "End of phase."
		)

end
