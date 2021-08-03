let
	graph = QuellerGraph("phase_3_mili",
		"Military Strategy: Phase 3",
		"p3_1",
		)


	add!(graph, YesNoCondition("p3_1",
		"""
		Is the fellowship on the
		mordor track?
		""",
		"p3_1_yes",
		"p3_2"
		))
	add!(graph, PerformAction("p3_1_yes",
		"""
		Assign the maximum allowed
		number of dice to the hunt
		pool.
		""",
		"p3_end",
		))



	add!(graph, YesNoCondition("p3_2",
		"""
		Is the fellowships progress
		greater than 5?
		""",
		"p3_2_yes",
		"p3_3"
		))
	add!(graph, PerformAction("p3_2_yes",
		"""
		Assign 2 dice to the hunt pool.
		""",
		"p3_end",
		))



	add!(graph, YesNoCondition("p3_3",
		"""
		Is the fellowship at the
		starting position and is
		its progress is 0?
		""",
		"p3_3_yes",
		"p3_3_no"
		))
	add!(graph, PerformAction("p3_3_yes",
		"""
		Assign 0 dice to the hunt pool.
		""",
		"p3_end",
		))
	add!(graph, PerformAction("p3_3_no",
		"""
		Assign 1 dice to the hunt pool.
		""",
		"p3_end",
		))

	add!(graph, EndNode("p3_end", "End of phase."))

end
