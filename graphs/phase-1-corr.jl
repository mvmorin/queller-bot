let
	[
	 StartNode(
			   id = "phase_1_corr",
			   text = "Phase 1: Corruption Strategy",
			   next_node = "p1_1",
			   )

	 PerformAction(
				   id = "p1_1",
				   action = """
				   Recover action dice.
				   """,
				   next_node = "p1_2",
				   )
	 PerformAction(
				   id = "p1_2",
				   action = """
				   Draw event cards.
				   """,
				   next_node = "p1_3",
				   )



	 YesNoCondition(
					id = "p1_3",
					condition = """
					Is more than 6 card held?
					""",
					next_node_yes = "p1_discard",
					next_node_no = "p1_end_1",
					)
	 YesNoCondition(
					id = "p1_discard",
					condition = """
					Is more than 1 strategy card held?
					""",
					next_node_yes = "p1_discard_1",
					next_node_no = "p1_discard_2",
					)
	 PerformAction(
				   id = "p1_discard_1",
				   action = """
				   Discard event cards down to 6.

				   Priority:

				   1. Doesn't use the term "Fellowship revealed"
				   2. Doesn't place a tile
				   3. Strategy card
				   4. Character card
				   5. Descending order of initiative
				   """,
				   next_node = "p1_end_2",
				   )
	 PerformAction(
				   id = "p1_discard_2",
				   action = """
				   Discard event cards down to 6.

				   Priority:

				   1. Doesn't use the term "Fellowship revealed"
				   2. Doesn't place a tile
				   3. Character card
				   4. Strategy card
				   5. Descending order of initiative
				   """,
				   next_node = "p1_end_2",
				   )



	 EndNode(
			 id = "p1_end_1",
			 text = "End of Phase"
			 )
	 EndNode(
			 id = "p1_end_2",
			 text = "End of Phase"
			 )
	 ]
end
