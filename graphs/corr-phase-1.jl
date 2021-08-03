let
	graph = QuellerGraph("phase_1_corr",
		"Corruption Strategy: Phase 1",
		"p1_1",
		)



	add!(graph, PerformAction("p1_1",
		"""
		Recover action dice.
		""",
		"p1_2",
		))
	add!(graph, PerformAction("p1_2",
		"""
		Draw event cards.
		""",
		"p1_3",
		))



	add!(graph, YesNoCondition("p1_3",
		"""
		Is more than 6 card held?
		""",
		"p1_discard",
		"p1_end_1"
		))
	add!(graph, YesNoCondition("p1_discard",
		"""
		Is more than 1 strategy card held?
		""",
		"p1_discard_1",
		"p1_discard_2"
		))
	add!(graph, PerformAction("p1_discard_1",
		"""
		Discard event cards down to 6.

		Priority:

		1. Doesn't use the term "Fellowship revealed"
		2. Doesn't place a tile
		3. Strategy card
		4. Character card
		5. Descending order of initiative
		""",
		"p1_end_2",
		))
	add!(graph, PerformAction("p1_discard_2",
		"""
		Discard event cards down to 6.

		Priority:

		1. Doesn't use the term "Fellowship revealed"
		2. Doesn't place a tile
		3. Character card
		4. Strategy card
		5. Descending order of initiative
		""",
		"p1_end_2",
		))



	add!(graph, EndNode("p1_end_1", "End of phase."))
	add!(graph, EndNode("p1_end_2", "End of phase."))

end
