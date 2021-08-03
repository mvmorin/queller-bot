let
	graph = QuellerGraph("event",
		"Event Die",
		"event_die_check",
		)


	add!(graph, YesNoCondition("event_die_check",
		"""
		Is an event
		die available?
		""",
		"event_1",
		"event_die_check_no",
		))
	add!(graph, ReturnFromSubgraph("event_die_check_no",
		"""
		Continue from latest
		jump point.
		"""
		))



	add!(graph, YesNoCondition("event_1",
		"""
		Is a playable
		*preferred*
		card held?
		""",
		"event_1_yes",
		"event_2",
		))
	add!(graph, PerformAction("event_1_yes",
		"""
		Use event die to play card.

		Priority:

		1. *Preferred* Event Card
		2. Ascending Order of Initiative
		""",
		"event_1_yes_end"
		))
	add!(graph, EndNode("event_1_yes_end"))



	add!(graph, YesNoCondition("event_2",
		"""
		Is less than 4 cards held?
		""",
		"event_2_yes",
		"event_3",
		))
	add!(graph, PerformAction("event_2_yes",
		"""
		Use event die to draw
		a *preferred* card.
		""",
		"event_2_yes_end"
		))
	add!(graph, EndNode("event_2_yes_end"))



	add!(graph, YesNoCondition("event_3",
		"""
		Is a playable event card held?
		""",
		"event_3_yes",
		"event_3_no",
		))
	add!(graph, PerformAction("event_3_yes",
		"""
		Use event die to play card.

		Priority: Ascending Order of Initiative
		""",
		"event_3_yes_end"
		))
	add!(graph, EndNode("event_3_yes_end"))



	add!(graph, PerformAction("event_3_no",
		"""
		Use event die to draw
		a *preferred* card.
		""",
		"event_3_discard"
		))
	add!(graph, YesNoCondition("event_3_discard",
		"""
		Is more than 6 card held?
		""",
		"event_3_discard_yes",
		"event_3_discard_no",
		))
	add!(graph, PerformAction("event_3_discard_yes",
		"""
		Discard event cards down to 6.

		Priority:

		1. Not *Preferred* Event Card
		2. Doesn't use the term "Fellowship revealed"
		3. Doesn't place a tile
		4. Ascending order of initiative
		""",
		"event_3_discard_yes_end"
		))
	add!(graph, EndNode("event_3_discard_yes_end"))
	add!(graph, EndNode("event_3_discard_no"))

end
