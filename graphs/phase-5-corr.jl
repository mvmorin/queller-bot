let
	[
	 StartNode(
			   id = "phase_5_corr",
			   text = "Phase 5 Action: Corruption Strategy",
			   next = "p5_mods",
			   )

	 AvailableModifiers(
						id = "p5_mods",
						next = "p5_1_a",
						)

	 SelectActiveDie(
					 id = "p5_1_a",
					 next = "p5_1_a_jump",
					 next_no_die = "p5_1_m",
					 priority = "CAH",
					 may_use_ring = true,
					 )
	 JumpToGraph(
				 id = "p5_1_a_jump",
				 text = "Movement and Attack:\nThreat or Exposed",
				 jump_graph = "movement_attack_threat_exposed",
				 next = "p5_1_m",
				 )


	 SelectActiveDie(
					 id = "p5_1_m",
					 next = "p5_1_m_jump",
					 next_no_die = "p5_1_c",
					 priority = "MH",
					 may_use_ring = true,
					 )
	 JumpToGraph(
				 id = "p5_1_m_jump",
				 text = "Mustering: Threat",
				 jump_graph = "mustering_threat",
				 next = "p5_1_c",
				 )


	 SelectActiveDie(
					 id = "p5_1_c",
					 next = "p5_1_c_jump",
					 next_no_die = "p5_2",
					 priority = "C",
					 may_use_ring = true,
					 )
	 JumpToGraph(
				 id = "p5_1_c_jump",
				 text = "Characters:\nCharacter Movement",
				 jump_graph = "characters_move",
				 next = "p5_2",
				 )




	 # YesNoCondition(
					# id = "p5_1_cond",
					# condition = """
					# Is a shadow army under *threat*
					# or is a free peoples army *exposed*?
					# """,
					# next_yes = "p5_1_yes",
					# next_no = "p5_2",
					# )
	 # JumpToGraph(
				 # id = "p5_1_yes",
				 # text = "Threat or Exposed",
				 # jump_graph = "threat_or_exposed",
				 # next = "p5_2",
				 # )

	 # YesNoCondition(
					# id = "p5_2",
					# condition = """
					# Is the fellowship revealed or
					# on the Mordor track, and at
					# least one character card is
					# begin held?
					# """,
					# next_yes = "p5_2_yes",
					# next_no = "p5_3",
					# )
	 # JumpToGraph(
				 # id = "p5_2_yes",
				 # text = "Hunt with Card",
				 # jump_graph = "hunt_with_cards",
				 # next = "p5_3",
				 # )

	 # YesNoCondition(
					# id = "p5_3",
					# condition = """
					# Is the fellowship in a region
					# without any Nazgûl but the
					# Nazgûl can move to?
					# """,
					# next_yes = "p5_3_yes",
					# next_no = "p5_4",
					# )
	 # JumpToGraph(
				 # id = "p5_3_yes",
				 # text = "Character 2",
				 # jump_graph = "character_2",
				 # next = "p5_4",
				 # )

	 # YesNoCondition(
					# id = "p5_4",
					# condition = """
					# Is the Which King in play
					# but not in a *mobile* army?
					# """,
					# next_yes = "p5_4_yes",
					# next_no = "p5_5",
					# )
	 # JumpToGraph(
				 # id = "p5_4_yes",
				 # text = "Character 2",
				 # jump_graph = "character_2",
				 # next = "p5_5",
				 # )

	 # YesNoCondition(
					# id = "p5_5",
					# condition = """
					# Is any condition to muster
					# a minion met?
					# """,
					# next_yes = "p5_5_yes",
					# next_no = "p5_6",
					# )
	 # JumpToGraph(
				 # id = "p5_5_yes",
				 # text = "Muster 2",
				 # jump_graph = "muster_2",
				 # next = "p5_6",
				 # )

	 # YesNoCondition(
					# id = "p5_6",
					# condition = """
					# Is the Southrons & Easterlings
					# not at war?
					# """,
					# next_yes = "p5_6_yes",
					# next_no = "p5_7",
					# )
	 # JumpToGraph(
				 # id = "p5_6_yes",
				 # text = "Muster 2",
				 # jump_graph = "muster_2",
				 # next = "p5_7",
				 # )

	# YesNoCondition(
				   # id = "p5_7",
				   # condition = """
				   # Is a *mobile* army adjacent
				   # to its *target*?
				   # """,
				   # next_yes = "p5_7_1",
				   # next_no = "p5_8",
				   # )
	# YesNoCondition(
				   # id = "p5_7_1",
				   # condition = """
				   # Is the fellowship on the
				   # Mordor track or would the
				   # shadow player win if one
				   # army's *target* were to be
				   # defeated?
				   # """,
				   # next_yes = "p5_7_yes",
				   # next_no = "p5_7_2",
				   # )
	# YesNoCondition(
				   # id = "p5_7_2",
				   # condition = """
				   # Does an army have a *target*
				   # in a nation at war but the
				   # *target* is not under serige?
				   # """,
				   # next_yes = "p5_7_yes",
				   # next_no = "p5_8",
				   # )
	 # JumpToGraph(
				 # id = "p5_7_yes",
				 # text = "Character",
				 # jump_graph = "character",
				 # next = "p5_7_yes_1",
				 # )
	 # JumpToGraph(
				 # id = "p5_7_yes_1",
				 # text = "Army 4",
				 # jump_graph = "army_4",
				 # next = "p5_8",
				 # )

	 # YesNoCondition(
					# id = "p5_8",
					# condition = """
					# Is the shadow player
					# allowed to pass?
					# """,
					# next_yes = "p5_8_yes",
					# next_no = "p5_9",
					# )
	 # PerformAction(
				   # id = "p5_8_yes",
				   # action = """
				   # Pass
				   # """,
				   # next = "p5_8_end",
				   # )
	 # EndNode(id = "p5_8_end")

	 # YesNoCondition(
					# id = "p5_9",
					# condition = """
					# Is more than zero event
					# cards held?
					# """,
					# next_yes = "p5_9_yes",
					# next_no = "p5_10",
					# )
	 # JumpToGraph(
				 # id = "p5_9_yes",
				 # text = "Character Play Card",
				 # jump_graph = "character_play_card",
				 # next = "p5_9_yes_1",
				 # )
	 # JumpToGraph(
				 # id = "p5_9_yes_1",
				 # text = "Event",
				 # jump_graph = "event",
				 # next = "p5_10",
				 # )

	 # YesNoCondition(
					# id = "p5_10",
					# condition = """
					# Is there a *mobile* army
					# adjacent to its *target*
					# but the *target* is not
					# under seige?
					# """,
					# next_yes = "p5_10_yes",
					# next_no = "p5_11",
					# )
	 # JumpToGraph(
				 # id = "p5_10_yes",
				 # text = "Character",
				 # jump_graph = "character",
				 # next = "p5_10_yes_1",
				 # )
	 # JumpToGraph(
				 # id = "p5_10_yes_1",
				 # text = "Army 2",
				 # jump_graph = "army_2",
				 # next = "p5_11",
				 # )

	 # JumpToGraph(
				 # id = "p5_11",
				 # text = "Event",
				 # jump_graph = "event",
				 # next = "p5_12",
				 # )
	 # JumpToGraph(
				 # id = "p5_12",
				 # text = "Army 3",
				 # jump_graph = "army_3",
				 # next = "p5_13",
				 # )
	 # JumpToGraph(
				 # id = "p5_13",
				 # text = "Character",
				 # jump_graph = "character",
				 # next = "p5_14",
				 # )
	 # JumpToGraph(
				 # id = "p5_14",
				 # text = "Muster",
				 # jump_graph = "muster",
				 # next = "p5_15",
				 # )

	 ]
end
