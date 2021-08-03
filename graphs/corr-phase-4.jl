let
	graph = QuellerGraph("phase_4_corr",
		"Corruption Strategy: Phase 4",
		"p4_1",
		)

	add!(graph, PerformAction("p4_1",
		"""
		Roll the remaining action dice.
		""",
		"p4_end",
		))

	add!(graph, EndNode("p4_end", "End of phase."))

end
