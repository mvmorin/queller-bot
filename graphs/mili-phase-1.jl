let
	graph = QuellerGraph("phase_1_mili",
		"Military Strategy: Phase 1",
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
		"p1_end"
		))
	add!(graph, PerformAction("p1_discard",
		"""
		Discard event cards down to 6.

		Priority:

		1. Doesn't use the term "Fellowship revealed"
		2. Character card
		3. Strategy card
		4. Descending order of initiative
		5. Doesn't place a tile
		""",
		"p1_end",
		))

	add!(graph, EndNode("p1_end", "End of phase."))

end
