let
	[
	 ################################################################################
	 StartNode(
			   id = "select_action_corr",
			   text = "Select Action:\nCorruption Strategy",
			   next = "threat_check",
			   )
	 JumpToGraph(
				 id = "threat_check",
				 text = "Threat or Exposed",
				 jump_graph = "threat_exposed",
				 next = "a1",
				 )


	 ########################################
	 DummyNode(id = "a1", next = "a1_1")
	 SetActiveDie(
				  id = "a1_1",
				  next = "a1_2",
				  next_no_die = "a2",
				  die = 'C',
				  may_use_ring = true,
				  )
	 SetActiveDie(
				  id = "a1_2",
				  next = "a1_cond",
				  next_no_die = "a2",
				  die = 'P',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "a1_cond",
					 condition = """
					 The Fellowship is on the Mordor track or is revealed.
					 And, a character card is held.
					 """,
					 next_true = "a1_jump",
					 next_false = "a2",
					 )
	 JumpToGraph(
				 id = "a1_jump",
				 next = "a2",
				 text = "Event Cards: Corruption",
				 jump_graph = "event_cards_corruption",
				 )

	 #######################################
	 DummyNode(id = "a2", next = "a2_1")
	 SetActiveDie(
				  id = "a2_1",
				  next = "a2_cond",
				  next_no_die = "a3",
				  die = 'C',
				  )
	 BinaryCondition(
					 id = "a2_cond",
					 condition = """
					 The Fellowship is in a region with no Nazgûl and which Nazgûl can move to.
					 """,
					 next_true = "a2_jump",
					 next_false = "a3",
					 )
	 JumpToGraph(
				 id = "a2_jump",
				 text = "Character: Movement",
				 jump_graph = "character_move",
				 next = "a3",
				 )

	 #######################################
	 DummyNode(id = "a3", next = "a3_1")
	 SetActiveDie(
				  id = "a3_1",
				  next = "a3_cond",
				  next_no_die = "a4",
				  die = 'C',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "a3_cond",
					 condition = """
					 The Which King is in play and not in a *mobile* army but is able to create or join one.
					 """,
					 next_true = "a3_jump",
					 next_false = "a4",
					 )
	 JumpToGraph(
				 id = "a3_jump",
				 text = "Character: Which King",
				 jump_graph = "characters_which_king",
				 next = "a4",
				 )


	 ########################################
	 DummyNode(id = "a4", next = "a4_1")
	 SetActiveDie(
				  id = "a4_1",
				  next = "a4_jump",
				  next_no_die = "a5",
				  die = 'M',
				  may_use_ring = true,
				  )
	 JumpToGraph(
				 id = "a4_jump",
				 text = "Muster: Minion",
				 jump_graph = "muster_minion",
				 next = "a5",
				 )


	 ########################################
	 DummyNode(id = "a5", next = "a5_1")
	 SetActiveDie(
				  id = "a5_1",
				  next = "a5_jump",
				  next_no_die = "a6",
				  die = 'M',
				  )
	 JumpToGraph(
				 id = "a5_jump",
				 text = "Muster: Politics",
				 jump_graph = "muster_politics",
				 next = "a6",
				 )


	 ########################################
	 DummyNode(id = "a6", next = "a6_1_ring")
	 SetActiveDie(
				  id = "a6_1_ring",
				  next = "a6_cond_ring",
				  next_no_die = "a6_2_ring",
				  die = 'C',
				  may_use_ring = true,
				  )
	 SetActiveDie(
				  id = "a6_2_ring",
				  next = "a6_cond_ring",
				  next_no_die = "a7",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "a6_cond_ring",
					 condition = """
					 A *mobile* army is adjacent to its *target*.
					 And, the *target* gives enough points to win or the Fellowship is on the Mordor track.
					 """,
					 next_true = "a6_jump_1_die_ring",
					 next_false = "a6_1_no_ring",
					 )
	 SetActiveDie(
				  id = "a6_jump_1_die_ring",
				  next = "a6_jump_1_ring",
				  next_no_die = "a6_jump_2_die_ring",
				  die = 'C',
				  may_use_ring = true,
				  )
	 JumpToGraph(
				 id = "a6_jump_1_ring",
				 text = "Character: Army Movement",
				 jump_graph = "character_army",
				 next = "a6_jump_2_die_ring",
				 )
	 SetActiveDie(
				  id = "a6_jump_2_die_ring",
				  next = "a6_jump_2_ring",
				  next_no_die = "a7",
				  die = 'A',
				  may_use_ring = true,
				  )
	 JumpToGraph(
				 id = "a6_jump_2_ring",
				 text = "Movement and Attack: Basic",
				 jump_graph = "movement_attack_basic",
				 next = "a7",
				 )



	 SetActiveDie(
				  id = "a6_1_no_ring",
				  next = "a6_cond_no_ring",
				  next_no_die = "a6_2_no_ring",
				  die = 'C',
				  )
	 SetActiveDie(
				  id = "a6_2_no_ring",
				  next = "a6_cond_no_ring",
				  next_no_die = "a7",
				  die = 'A',
				  )
	 BinaryCondition(
					 id = "a6_cond_no_ring",
					 condition = """
					 A *mobile* army is adjacent to its *target*.
					 And, the *target* is in a nation at war and not under siege.
					 """,
					 next_true = "a6_jump_1_die_no_ring",
					 next_false = "a7",
					 )
	 SetActiveDie(
				  id = "a6_jump_1_die_no_ring",
				  next = "a6_jump_1_no_ring",
				  next_no_die = "a6_jump_2_die_no_ring",
				  die = 'C',
				  )
	 JumpToGraph(
				 id = "a6_jump_1_no_ring",
				 text = "Character: Army Movement",
				 jump_graph = "character_army",
				 next = "a6_jump_2_die_no_ring",
				 )
	 SetActiveDie(
				  id = "a6_jump_2_die_no_ring",
				  next = "a6_jump_2_no_ring",
				  next_no_die = "a7",
				  die = 'A',
				  )
	 JumpToGraph(
				 id = "a6_jump_2_no_ring",
				 text = "Movement and Attack: Basic",
				 jump_graph = "movement_attack_basic",
				 next = "a7",
				 )


	 ########################################
	 DummyNode(id = "a7", next = "a7_1")
	 BinaryCondition(
					 id = "a7_1",
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
	 DummyNode(id = "a8", next = "a8_1")
	 SetActiveDie(
				  id = "a8_1",
				  next = "a8_jump_1",
				  next_no_die = "a8_2",
				  die = 'C',
				  )
	 JumpToGraph(
				 id = "a8_jump_1",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "a8_2",
				 )
	 SetActiveDie(
				  id = "a8_2",
				  next = "a8_jump_2",
				  next_no_die = "a9",
				  die = 'P',
				  )
	 JumpToGraph(
				 id = "a8_jump_2",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "a9",
				 )


	 ########################################
	 DummyNode(id = "a9", next = "a9_1")
	 SetActiveDie(
				  id = "a9_1",
				  next = "a9_cond",
				  next_no_die = "a9_2",
				  die = 'C',
				  )
	 SetActiveDie(
				  id = "a9_2",
				  next = "a9_cond",
				  next_no_die = "a10",
				  die = 'A',
				  )
	 BinaryCondition(
					 id = "a9_cond",
					 condition = """
					 A *mobile* army is adjacent to its *target* that is not under siege.
					 """,
					 next_true = "a9_jump_1_die",
					 next_false = "a10",
					 )
	 SetActiveDie(
				  id = "a9_jump_1_die",
				  next = "a9_jump_1",
				  next_no_die = "a9_jump_2_die",
				  die = 'C',
				  )
	 JumpToGraph(
				 id = "a9_jump_1",
				 text = "Character: Army Movement",
				 jump_graph = "character_army",
				 next = "a9_jump_2_die",
				 )
	 SetActiveDie(
				  id = "a9_jump_2_die",
				  next = "a9_jump_2",
				  next_no_die = "a10",
				  die = 'A',
				  )
	 JumpToGraph(
				 id = "a9_jump_2",
				 text = "Movement and Attack: Basic",
				 jump_graph = "movement_attack_basic",
				 next = "a10",
				 )


	 #######################################
	 DummyNode(id = "a10", next = "a10_start")
	 SetActiveDie(
				  id = "a10_start",
				  next = "a10_1",
				  next_no_die = "a11",
				  die = 'P',
				  )
	 JumpToGraph(
				 id = "a10_1",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "a10_2",
				 )
	 JumpToGraph(
				 id = "a10_2",
				 text = "Event Cards: General",
				 jump_graph = "event_cards_general",
				 next = "a11",
				 )



	 ########################################
	 DummyNode(id = "a11", next = "a11_1")
	 SetActiveDie(
				  id = "a11_1",
				  next = "a11_action",
				  next_no_die = "a12",
				  die = 'A',
				  )
	 JumpToGraph(
				 id = "a11_action",
				 text = "Movement and Attack:\nCorruption",
				 jump_graph = "movement_attack_corr",
				 next = "a12",
				 )


	 ########################################
	 DummyNode(id = "a12", next = "a12_start")
	 SetActiveDie(
				  id = "a12_start",
				  next = "a12_1",
				  next_no_die = "a13",
				  die = 'C',
				  )
	 JumpToGraph(
				 id = "a12_1",
				 text = "Character: Army Movement",
				 jump_graph = "character_army",
				 next = "a13",
				 )

	 ########################################
	 DummyNode(id = "a13", next = "a13_start")
	 SetActiveDie(
				  id = "a13_start",
				  next = "a13_1",
				  next_no_die = "a14",
				  die = 'M',
				  )
	 JumpToGraph(
				 id = "a13_1",
				 text = "Muster: Minion",
				 jump_graph = "muster_minion",
				 next = "a13_2",
				 )
	 JumpToGraph(
				 id = "a13_2",
				 text = "Muster: Politics",
				 jump_graph = "muster_politics",
				 next = "a13_3",
				 )
	 JumpToGraph(
				 id = "a13_3",
				 text = "Muster: Muster",
				 jump_graph = "muster_muster",
				 next = "a14",
				 )


	 ########################################
	 DummyNode(id = "a14", next = "a14_1")
	 SetRandomDie(
				  id = "a14_1",
				  next = "a14_die",
				  )
	 UseActiveDie(
				  id = "a14_die",
				  next = "a14_action",
				  )
	 PerformAction(
				   id = "a14_action",
				   action = "Discard die and do nothing. (Queller failed to find an action.)",
				   next = "a_end",
				   )
	 EndNode(id = "a_end")

	 ]
end
