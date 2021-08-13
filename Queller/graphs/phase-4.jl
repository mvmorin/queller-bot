let
	[
	 StartNode(
			   id = "phase_4_mili",
			   text = "Phase 4: Military Strategy",
			   next = "p4_1",
			   )

	 StartNode(
			   id = "phase_4_corr",
			   text = "Phase 4: Corruption Strategy",
			   next = "p4_1",
			   )

	 RollActionDice(
					id = "p4_1",
					next = "p4_end",
					)

	 EndNode(
			 id = "p4_end",
			 text = "End of Phase",
			 )

	 ]
end
