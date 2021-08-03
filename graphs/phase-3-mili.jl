let
	[
	 StartNode(
			   id = "phase_3_mili",
			   text = "Phase 3: Military Strategy",
			   next_node = "p3_1",
			   )


	 YesNoCondition(
					id = "p3_1",
					condition = """
					Is the fellowship on the
					mordor track?
					""",
					next_node_yes = "p3_1_yes",
					next_node_no = "p3_2"
					)
	 PerformAction(
				   id = "p3_1_yes",
				   action = """
				   Assign the maximum allowed
				   number of dice to the hunt
				   pool.
				   """,
				   next_node = "p3_end",
				   )


	 YesNoCondition(
					id = "p3_2",
					condition = """
					Is the fellowships progress
					greater than 5?
					""",
					next_node_yes = "p3_2_yes",
					next_node_no = "p3_3",
					)
	 PerformAction(
				   id = "p3_2_yes",
				   action = """
				   Assign 2 dice to the hunt pool.
				   """,
				   next_node = "p3_end",
				   )


	 YesNoCondition(
					id = "p3_3",
					condition = """
					Is the fellowship at the
					starting position and is
					its progress is 0?
					""",
					next_node_yes = "p3_3_yes",
					next_node_no = "p3_3_no",
					)
	 PerformAction(
				   id = "p3_3_yes",
				   action = """
				   Assign 0 dice to the hunt pool.
				   """,
				   next_node = "p3_end",
				   )
	 PerformAction(
				   id = "p3_3_no",
				   action = """
				   Assign 1 dice to the hunt pool.
				   """,
				   next_node = "p3_end",
				   )

	 EndNode(
			 id = "p3_end",
			 text = "End of Phase",
			 )

	 ]
end
