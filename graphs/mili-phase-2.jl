let
	graph = QuellerGraph("phase_2_mili",
		"Military Strategy: Phase 2",
		"p2_1",
		)


	add!(graph, YesNoCondition("p2_1",
		"""
		After the free peoples player have
		chosed whether to reveal, is the
		shadow victory points lower than
		the corruption points?
		""",
		"p2_mili",
		"p2_end"
		))

	add!(graph, PerformAction("p2_mili",
		"""
		Use the corruption strategy for the
		remaining phases of the turn.
		""",
		"p2_end",
		))

	add!(graph, EndNode("p2_end", "End of phase."))

end
