let
	[
	 # Military
	 StartNode(
			   id = "phase_2_mili",
			   text = "Phase 2: Military Strategy",
			   next = "p2_mili_1",
			   )

	 YesNoCondition(
					id = "p2_mili_1",
					condition = """
					After the free peoples player have
					chosed whether to reveal, is the
					shadow victory points lower than
					the corruption points?
					""",
					next_yes = "p2_mili_change",
					next_no = "p2_mili_end",
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

	 YesNoCondition(
					id = "p2_corr_1",
					condition = """
					After the free peoples player have
					chosed whether to reveal, is the
					corruption points lower than the
					shadow victory points?
					""",
					next_yes = "p2_corr_change",
					next_no = "p2_corr_end",
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
