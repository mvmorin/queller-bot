let
	[
	 # Military
	 StartNode(
			   id = "phase_2_mili",
			   text = "Phase 2: Military Strategy",
			   next = "p2_mili_1",
			   )

	 BinaryCondition(
					id = "p2_mili_1",
					condition = """
					The Shadow victory points are lower than the corruption points, after the Free Peoples' have chosen whether to reveal.
					""",
					next_true = "p2_mili_change",
					next_false = "p2_mili_end",
					)

	 SetStrategy(
				 id = "p2_mili_change",
				 strategy = "corruption",
				 next = "p2_mili_end",
				 )

	 EndNode(
			 id = "p2_mili_end",
			 text = "End of Phase",
			 )


	 # Corruption
	 StartNode(
			   id = "phase_2_corr",
			   text = "Phase 2: Corruption Strategy",
			   next = "p2_corr_1",
			   )

	 BinaryCondition(
					id = "p2_corr_1",
					condition = """
					The corruption points are lower than the the Shadow victory points, after the Free Peoples' have chosen whether to reveal.
					""",
					next_true = "p2_corr_change",
					next_false = "p2_corr_end",
					)

	 SetStrategy(
				 id = "p2_corr_change",
				 strategy = "military",
				 next = "p2_corr_end",
				 )

	 EndNode(
			 id = "p2_corr_end",
			 text = "End of Phase",
			 )
	 ]
end
