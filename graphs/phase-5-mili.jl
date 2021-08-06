let
	[
	 StartNode(
			   id = "phase_5_mili",
			   text = "Phase 5 Action:\nMilitary Strategy",
			   next = "p5_mods",
			   )

	 AvailableModifiers(
						id = "p5_mods",
						next = "p5_1",
						)

	 SetActiveDie(
				  id = "p5_1",
				  next = "p5_1_cond",
				  next_no_die = "p5_2",
				  die = 'C',
				  may_use_ring = true,
				  )
	 YesNoCondition(
					id = "p5_1_cond",
					condition = """
					Is the shadow under *threat*
					or is a *target* *exposed*?
					""",
					next_yes = "p5_1_jump_1",
					next_no = "p5_2",
					)
	 JumpToGraph(
				 id = "p5_1_jump_1",
				 text = "Movement and Attack:\nThreat or Exposed",
				 jump_graph = "movement_attack_threat_exposed",
				 next = "p5_1_jump_2",
				 )

	 ]
end
