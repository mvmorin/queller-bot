let
	[
	 StartNode(
			   id = "phase_1_mili",
			   text = "Phase 1: Military Strategy",
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
					next_node_no = "p1_end",
					)
	 PerformAction(
				   id = "p1_discard",
				   action = """
				   Discard event cards down to 6.

				   Priority:

				   1. Doesn't use the term "Fellowship revealed"
				   2. Character card
				   3. Strategy card
				   4. Descending order of initiative
				   5. Doesn't place a tile
				   """,
				   next_node = "p1_end",
				   )

	 EndNode(
			 id = "p1_end",
			 text = "End of Phase",
			 )

	 ]
end
