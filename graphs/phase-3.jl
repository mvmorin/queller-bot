let
	[
	 # Military
	 StartNode(
			   id = "phase_3_mili",
			   text = "Phase 3: Military Strategy",
			   next = "p3_mili_1",
			   )


	 YesNoCondition(
					id = "p3_mili_1",
					condition = """
					Is the fellowship on the
					mordor track?
					""",
					next_yes = "p3_mili_1_yes",
					next_no = "p3_mili_2"
					)
	 PerformAction(
				   id = "p3_mili_1_yes",
				   action = """
				   Assign the maximum allowed
				   number of dice to the hunt
				   pool.
				   """,
				   next = "p3_mili_end",
				   )


	 YesNoCondition(
					id = "p3_mili_2",
					condition = """
					Is the fellowships progress
					greater than 5?
					""",
					next_yes = "p3_mili_2_yes",
					next_no = "p3_mili_3",
					)
	 PerformAction(
				   id = "p3_mili_2_yes",
				   action = """
				   Assign 2 dice to the hunt pool.
				   """,
				   next = "p3_mili_end",
				   )


	 YesNoCondition(
					id = "p3_mili_3",
					condition = """
					Is the fellowship at the
					starting position and is
					its progress is 0?
					""",
					next_yes = "p3_mili_3_yes",
					next_no = "p3_mili_3_no",
					)
	 PerformAction(
				   id = "p3_mili_3_yes",
				   action = """
				   Assign 0 dice to the hunt pool.
				   """,
				   next = "p3_mili_end",
				   )
	 PerformAction(
				   id = "p3_mili_3_no",
				   action = """
				   Assign 1 dice to the hunt pool.
				   """,
				   next = "p3_mili_end",
				   )

	 EndNode(
			 id = "p3_mili_end",
			 text = "End of Phase",
			 )


	# Corruption
	 StartNode(
			   id = "phase_3_corr",
			   text = "Phase 3: Corruption Strategy",
			   next = "p3_corr_1",
			   )



	 YesNoCondition(
					id = "p3_corr_1",
					condition = """
					Is the fellowship at the
					starting position and is
					its progress is 0?
					""",
					next_yes = "p3_corr_1_yes",
					next_no = "p3_corr_2",
					)
	 PerformAction(
				   id = "p3_corr_1_yes",
				   action = """
				   Roll a d6. On 4+, assign
				   1 die to the hunt pool,
				   otherwise do nothing.
				   """,
				   next = "p3_corr_end",
				   )



	 YesNoCondition(
					id = "p3_corr_2",
					condition = """
					Is the fellowship on the
					mordor track?
					""",
					next_yes = "p3_corr_2_yes",
					next_no = "p3_corr_3",
					)
	 PerformAction(
				   id = "p3_corr_2_yes",
				   action = """
				   Assign the maximum allowed
				   number of dice to the hunt
				   pool.
				   """,
				   next = "p3_corr_end",
				   )



	 YesNoCondition(
					id = "p3_corr_3",
					condition = """
					Is a *mobile* army adjecent
					to *target* which would the
					game if it attacked or does
					the shadow only has 7 dice?
					""",
					next_yes = "p3_corr_3_yes",
					next_no = "p3_corr_4",
					)
	 PerformAction(
				   id = "p3_corr_3_yes",
				   action = """
				   Assign 1 die to the hunt pool.
				   """,
				   next = "p3_corr_end",
				   )



	 YesNoCondition(
					id = "p3_corr_4",
					condition = """
					Is the fellowships progress
					greater than 4?
					""",
					next_yes = "p3_corr_4_yes",
					next_no = "p3_corr_5",
					)
	 PerformAction(
				   id = "p3_corr_4_yes",
				   action = """
				   Assign 2 dice to the hunt pool.
				   """,
				   next = "p3_corr_end",
				   )



	 YesNoCondition(
					id = "p3_corr_5",
					condition = """
					Does the shortest path to morder
					for the fellowship lead via a
					shadow stronghold and the progress
					allows them to pass it or be
					within 2 steps from it?
					""",
					next_yes = "p3_corr_5_yes",
					next_no = "p3_corr_5_no",
					)
	 PerformAction(
				   id = "p3_corr_5_yes",
				   action = """
				   Assign 2 dice to the hunt pool.
				   """,
				   next = "p3_corr_end",
				   )
	 PerformAction(
				   id = "p3_corr_5_no",
				   action = """
				   Assign 1 dice to the hunt pool.
				   """,
				   next = "p3_corr_end",
				   )


	 EndNode(
			 id = "p3_corr_end",
			 text = "End of phase."
			 )

	 ]
end
