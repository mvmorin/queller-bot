let
	graph = QuellerGraph("phase_3_corr",
		"Corruption Strategy: Phase 3",
		"p3_1",
		)



	add!(graph, YesNoCondition("p3_1",
		"""
		Is the fellowship at the
		starting position and is
		its progress is 0?
		""",
		"p3_1_yes",
		"p3_2"
		))
	add!(graph, PerformAction("p3_1_yes",
		"""
		Roll a d6. On 4+, assign
		1 die to the hunt pool,
		otherwise do nothing.
		""",
		"p3_end",
		))



	add!(graph, YesNoCondition("p3_2",
		"""
		Is the fellowship on the
		mordor track?
		""",
		"p3_2_yes",
		"p3_3"
		))
	add!(graph, PerformAction("p3_2_yes",
		"""
		Assign the maximum allowed
		number of dice to the hunt
		pool.
		""",
		"p3_end",
		))



	add!(graph, YesNoCondition("p3_3",
		"""
		Is a *mobile* army adjecent
		to *target* which would the
		game if it attacked or does
		the shadow only has 7 dice?
		""",
		"p3_3_yes",
		"p3_4"
		))
	add!(graph, PerformAction("p3_3_yes",
		"""
		Assign 1 die to the hunt pool.
		""",
		"p3_end",
		))



	add!(graph, YesNoCondition("p3_4",
		"""
		Is the fellowships progress
		greater than 4?
		""",
		"p3_4_yes",
		"p3_5"
		))
	add!(graph, PerformAction("p3_4_yes",
		"""
		Assign 2 dice to the hunt pool.
		""",
		"p3_end",
		))



	add!(graph, YesNoCondition("p3_5",
		"""
		Does the shortest path to morder
		for the fellowship lead via a
		shadow stronghold and the progress
		allows them to pass it or be
		within 2 steps from it?
		""",
		"p3_5_yes",
		"p3_5_no"
		))
	add!(graph, PerformAction("p3_5_yes",
		"""
		Assign 2 dice to the hunt pool.
		""",
		"p3_end",
		))
	add!(graph, PerformAction("p3_5_no",
		"""
		Assign 1 dice to the hunt pool.
		""",
		"p3_end",
		))


	add!(graph, EndNode("p3_end", "End of phase."))

end
