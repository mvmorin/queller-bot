let
	[
	 StartNode(
			   id = "phase_4_corr",
			   text = "Phase 4: Corruption and Military Strategy",
			   next_node = "p4_1",
			   )

	 PerformAction(
				   id = "p4_1",
				   action = """
				   Roll the remaining action dice.
				   """,
				   next_node = "p4_end",
				   )

	 EndNode(
			 id = "p4_end",
			 text = "End of Phase",
			 )

	 ]
end
