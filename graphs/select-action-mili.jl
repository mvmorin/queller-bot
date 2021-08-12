let
	[
	 ################################################################################
	 StartNode(
			   id = "select_action_mili",
			   text = "Select Action:\nMilitary Strategy",
			   next = "threat_check",
			   )
	 JumpToGraph(
				 id = "threat_check",
				 text = "Threat or Exposed",
				 jump_graph = "threat_exposed",
				 next = "a1",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a1",
				  next = "a1_cond",
				  next_no_die = "a2",
				  die = 'C',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "a1_cond",
					 condition = """
					 The Which King is in play and not in a *mobile* army but is able to create or join one.
					 """,
					 next_true = "a1_jump",
					 next_false = "a2",
					 )
	 JumpToGraph(
				 id = "a1_jump",
				 text = "Character: Which King",
				 jump_graph = "characters_which_king",
				 next = "a2",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a2",
				  next = "a2_jump",
				  next_no_die = "a3",
				  die = 'M',
				  may_use_ring = true,
				  )
	 JumpToGraph(
				 id = "a2_jump",
				 text = "Muster: Minion",
				 jump_graph = "muster_minion",
				 next = "a3",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a3",
				  next = "a3_jump",
				  next_no_die = "a4",
				  die = 'M',
				  )
	 JumpToGraph(
				 id = "a3_jump",
				 text = "Muster: Politics",
				 jump_graph = "muster_politics",
				 next = "a4",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a4",
				  next = "a4_1",
				  next_no_die = "a5",
				  die = 'C',
				  may_use_ring = true,
				  )
	 SetActiveDie(
				  id = "a4_1",
				  next = "a4_cond",
				  next_no_die = "a5",
				  die = 'P',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "a4_cond",
					 condition = """
					 The Fellowship is on the Mordor track or is revealed.
					 And, a "Fellowship revealed" character card is held.
					 """,
					 next_true = "a4_die",
					 next_false = "a5",
					 )
	 UseActiveDie(
				  id = "a4_die",
				  next = "a4_action",
				  )
	 PerformAction(
				   id = "a4_action",
				   action = """
				   Play a "Fellowship revealed" character card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """,
				   next = "a4_end",
				   )
	 EndNode(id = "a4_end")


	 ########################################
	 SetActiveDie(
				  id = "a5",
				  next = "a5_1",
				  next_no_die = "a6",
				  die = 'C',
				  may_use_ring = true,
				  )
	 SetActiveDie(
				  id = "a5_1",
				  next = "a5_cond",
				  next_no_die = "a6",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "a5_cond",
					 condition = """
					 A *mobile* army is adjacent to its *target* or has another *mobile* army blocking the shortest route to *target*.

					 And, any of the following conditions hold:
					 - The *mobile* army's *target* gives enough points to win.
					 - The *mobile* army's *target* is in a nation at war and not under siege.
					 - The Fellowship is on the Mordor track.
					 """,
					 next_true = "a5_action",
					 next_false = "a6",
					 )
	 JumpToGraph(
				 id = "a5_action",
				 text = "Movement and Attack: Basic",
				 jump_graph = "movement_attack_basic",
				 next = "a6",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a6",
				  next = "a6_cond",
				  next_no_die = "a7",
				  die = 'M',
				  )
	 BinaryCondition(
					 id = "a6_cond",
					 condition = """
					 A strategy card that musters is *playable*.
					 """,
					 next_true = "a6_die",
					 next_false = "a6_2",
					 )
	 SetActiveDie(
				  id = "a6_2",
				  next = "a6_cond_2",
				  next_no_die = "a7",
				  die = 'A',
				  )
	 BinaryCondition(
					 id = "a6_cond_2",
					 condition = """
					 A strategy card that musters is *playable*.
					 """,
					 next_true = "a6_die",
					 next_false = "a7",
					 )
	 UseActiveDie(
				  id = "a6_die",
				  next = "a6_action",
				  )
	 PerformAction(
				   id = "a6_action",
				   action = """
				   Play a strategy card that musters.

				   Priority:
				   3. Ascending order of initiative
				   4. Random
				   """,
				   next = "a6_end",
				   )
	 EndNode(id = "a6_end")


	 ########################################
	 BinaryCondition(
					 id = "a7",
					 condition = "The Shadow player is allowed to pass.",
					 next_true = "a7_action",
					 next_false = "a8",
					 )
	 PerformAction(
				   id = "a7_action",
				   action = """
				   Pass
				   """,
				   next = "a7_end",
				   )
	 EndNode(id = "a7_end")


	 ########################################
	 SetActiveDie(
				  id = "a8",
				  next = "a8_jump_1",
				  next_no_die = "a9",
				  die = 'P',
				  )
	 JumpToGraph(
				 id = "a8_jump_1",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "a8_jump_2",
				 )
	 JumpToGraph(
				 id = "a8_jump_2",
				 text = "Event Cards: General",
				 jump_graph = "event_cards_general",
				 next = "a9",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a9",
				  next = "a9_1",
				  next_no_die = "a10",
				  die = 'C',
				  )
	 SetActiveDie(
				  id = "a9_1",
				  next = "a9_cond",
				  next_no_die = "a10",
				  die = 'A',
				  )
	 BinaryCondition(
					 id = "a9_cond",
					 condition = """
					 A *mobile* army is adjacent to its *target*.
					 """,
					 next_true = "a9_action",
					 next_false = "a10",
					 )
	 JumpToGraph(
				 id = "a9_action",
				 text = "Movement and Attack: Basic",
				 jump_graph = "movement_attack_basic",
				 next = "a10",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a10",
				  next = "a10_action",
				  next_no_die = "a11",
				  die = 'A',
				  )
	 JumpToGraph(
				 id = "a10_action",
				 text = "Movement and Attack: Corruption",
				 jump_graph = "movement_attack_corr",
				 next = "a11",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a11",
				  next = "a11_action",
				  next_no_die = "a12",
				  die = 'C',
				  )
	 JumpToGraph(
				 id = "a11_action",
				 text = "Character: Army Movement",
				 jump_graph = "character_army",
				 next = "a12",
				 )


	 ########################################
	 SetActiveDie(
				  id = "a12",
				  next = "a12_1",
				  next_no_die = "a13",
				  die = 'M',
				  )
	 JumpToGraph(
				 id = "a12_1",
				 text = "Muster: Minion",
				 jump_graph = "muster_minion",
				 next = "a12_2",
				 )
	 JumpToGraph(
				 id = "a12_2",
				 text = "Muster: Politics",
				 jump_graph = "muster_politics",
				 next = "a12_3",
				 )
	 JumpToGraph(
				 id = "a12_3",
				 text = "Muster: Muster",
				 jump_graph = "muster_muster",
				 next = "a13",
				 )


	 ########################################
	 SetRandomDie(
				  id = "a13",
				  next = "a13_die",
				  )
	 UseActiveDie(
				  id = "a13_die",
				  next = "a13_action",
				  )
	 PerformAction(
				   id = "a13_action",
				   action = "Discard die and do nothing. (Queller failed to find an action.)",
				   next = "a_end",
				   )
	 EndNode(id = "a_end")

	 ]
end
