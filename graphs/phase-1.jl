let
	[
	 # Military
	 StartNode(
			   id = "phase_1_mili",
			   text = "Phase 1: Military Strategy",
			   next = "p1_mili_1",
			   )



	 PerformAction(
				   id = "p1_mili_1",
				   action = """
				   Recover action dice.
				   """,
				   next = "p1_mili_2",
				   )
	 PerformAction(
				   id = "p1_mili_2",
				   action = """
				   Draw event cards.
				   """,
				   next = "p1_mili_3",
				   )



	 YesNoCondition(
					id = "p1_mili_3",
					condition = """
					Holding more than 6 cards.
					""",
					next_yes = "p1_mili_discard",
					next_no = "p1_mili_end",
					)
	 PerformAction(
				   id = "p1_mili_discard",
				   action = """
				   Discard event cards down to 6.

				   Priority:
				   1. Doesn't use the term "Fellowship revealed"
				   2. Character card
				   3. Strategy card
				   4. Descending order of initiative
				   5. Doesn't place a tile
				   """,
				   next = "p1_mili_end",
				   )

	 EndNode(
			 id = "p1_mili_end",
			 text = "End of Phase",
			 )

	 # Corruption
	 StartNode(
			   id = "phase_1_corr",
			   text = "Phase 1: Corruption Strategy",
			   next = "p1_corr_1",
			   )

	 PerformAction(
				   id = "p1_corr_1",
				   action = """
				   Recover action dice.
				   """,
				   next = "p1_corr_2",
				   )
	 PerformAction(
				   id = "p1_corr_2",
				   action = """
				   Draw event cards.
				   """,
				   next = "p1_corr_3",
				   )



	 YesNoCondition(
					id = "p1_corr_3",
					condition = """
					Holding more than 6 cards.
					""",
					next_yes = "p1_corr_discard",
					next_no = "p1_corr_end_1",
					)
	 YesNoCondition(
					id = "p1_corr_discard",
					condition = """
					Holding more than 1 strategy cards.
					""",
					next_yes = "p1_corr_discard_1",
					next_no = "p1_corr_discard_2",
					)
	 PerformAction(
				   id = "p1_corr_discard_1",
				   action = """
				   Discard event cards down to 6.

				   Priority:
				   1. Doesn't use the term "Fellowship revealed"
				   2. Doesn't place a tile
				   3. Strategy card
				   4. Character card
				   5. Descending order of initiative
				   """,
				   next = "p1_corr_end_2",
				   )
	 PerformAction(
				   id = "p1_corr_discard_2",
				   action = """
				   Discard event cards down to 6.

				   Priority:

				   1. Doesn't use the term "Fellowship revealed"
				   2. Doesn't place a tile
				   3. Character card
				   4. Strategy card
				   5. Descending order of initiative
				   """,
				   next = "p1_corr_end_2",
				   )



	 EndNode(
			 id = "p1_corr_end_1",
			 text = "End of Phase"
			 )
	 EndNode(
			 id = "p1_corr_end_2",
			 text = "End of Phase"
			 )
	 ]
end
