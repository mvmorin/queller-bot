let
	move_wk_cond = """
	The Witch King is not in an *mobile* army but is able to join or create one.
	"""

	wk_prio = """
	Move the Witch King, place it in a valid region according to the following priority.

	1. Army is *mobile*
	2. *Target* nation is at war
	3. Army becomes mobile if the Witch King is added
	4. Opposing army does not contain Gandalf the White
	5. Opposing army does not contain hobbits
	6. Adjacent to *threat*
	7. Army that is conduction a siege
	8. Army adjacent to its *target*
	9. Highest *value* Shadow army
	10. Random
	"""

	move_nazgul_cond = """
	No Nazgûls are in the Fellowship's region but they are able to move there.
	Or, a Nazgûl is in a non-*mobile* army but is able to join or create one.
	"""

	nazgul_prio = """
	Gather all Nazgûl and place them one at the time according to the following priority.

	1. One, and only one, in the Fellowship's region
	2. Army with leadership value less than the number of army units and 5
	3. Army which contain the Which King
	4. Shadow stronghold under siege
	5. *Mobile* army
	6. Army adjacent to *threat*
	7. Army whose *target* nation is active
	8. Army that becomes *mobile* if Nazgûl is added
	9. Army not sieging
	10. Army that is adjacent to its *target*
	11. Highest *value* shadow army
	12. Random
	"""

	move_mos_cond = """
	Mouth of Souron is not in a *mobile* army.
	"""

	mos_prio = """
	Move Mouth of Sauron.

	Priority:
	1. Towards army with leadership value less than the number of army units and 5
	2. Towards *mobile* army
	3. Towards army adjacent to its *target*
	4. Army which can be reach with this die
	5. Towards closest army
	6. Random
	"""

	[
	 ################################################################################
	 StartNode(
			   id = "character_army",
			   text = "Character:\n Army Movement",
			   next = "lc_1",
			   )

	 BinaryCondition(
					 id = "lc_1",
					 condition = """
					 *Aggressive* army with the Witch King or maximum leadership is adjacent to its *target*.
					 """,
					 next_true = "lc_1_yes",
					 next_false = "lc_2",
					 )
	 UseActiveDie(
				  id = "lc_1_yes",
				  next = "lc_1_action",
				  )
	 PerformAction(
				   id = "lc_1_action",
				   next = "lc_1_end",
				   action = """
				   Attack: Select army at random if severl armies satisfy the considered attack.
				   """
				   )
	 EndNode(id = "lc_1_end")

	 BinaryCondition(
					 id = "lc_2",
					 condition = """
					 *Mobile* army with leadership and a valid move/attack towards *target*.
					 """,
					 next_true = "lc_2_yes",
					 next_false = "lc_3",
					 )
	 JumpToGraph(
				 id = "lc_2_yes",
				 text = "Movement and Attack:\n Basic",
				 jump_graph = "movement_attack_basic",
				 next = "lc_3",
				 )


	 ################################################################################
	 StartNode(
			   id = "character_move",
			   text = "Character:\n Movement",
			   next = "lc_3",
			   )
	 BinaryCondition(
					 id = "lc_3",
					 condition = """
					 A Nazgûl or the Witch King is in play.
					 """,
					 next_true = "lc_wk",
					 next_false = "lc_3_no",
					 )
	 JumpToGraph(
				 id = "lc_3_no",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "lc_3_return",
				 )
	 ReturnFromGraph(
					 id = "lc_3_return",
					 )


	 ########################################
	 StartNode(
			   id = "character_which_king",
			   text = "Character:\n Which King",
			   next = "lc_wk_yes",
			   )

	 BinaryCondition(
					 id = "lc_wk",
					 condition = move_wk_cond,
					 next_true = "lc_wk_yes",
					 next_false = "lc_naz_1",
					 )
	 UseActiveDie(
				  id = "lc_wk_yes",
				  next = "lc_wk_action",
				  )
	 PerformAction(
				   id = "lc_wk_action",
				   next = "lc_naz_2",
				   action = wk_prio,
				   )


	 ########################################
	 BinaryCondition(
					 id = "lc_naz_1",
					 condition = move_nazgul_cond,
					 next_true = "lc_naz_1_yes",
					 next_false = "lc_mos_1",
					 )
	 UseActiveDie(
				  id = "lc_naz_1_yes",
				  next = "lc_naz_1_action",
				  )
	 PerformAction(
				   id = "lc_naz_1_action",
				   next = "lc_mos_2",
				   action = nazgul_prio,
				   )


	 BinaryCondition(
					 id = "lc_naz_2",
					 condition = move_nazgul_cond,
					 next_true = "lc_naz_2_yes",
					 next_false = "lc_mos_3",
					 )
	 UseActiveDie(
				  id = "lc_naz_2_yes",
				  next = "lc_naz_2_action",
				  )
	 PerformAction(
				   id = "lc_naz_2_action",
				   next = "lc_mos_4",
				   action = nazgul_prio,
				   )


	 ########################################
	 BinaryCondition(
					 id = "lc_mos_1",
					 condition = move_mos_cond,
					 next_true = "lc_mos_1_yes",
					 next_false = "lc_play_card",
					 )
	 UseActiveDie(
				  id = "lc_mos_1_yes",
				  next = "lc_mos_1_action",
				  )
	 PerformAction(
				   id = "lc_mos_1_action",
				   next = "lc_mos_end_1",
				   action = mos_prio,
				   )

	 BinaryCondition(
					 id = "lc_mos_2",
					 condition = move_mos_cond,
					 next_true = "lc_mos_2_yes",
					 next_false = "lc_mos_end_2",
					 )
	 UseActiveDie(
				  id = "lc_mos_2_yes",
				  next = "lc_mos_2_action",
				  )
	 PerformAction(
				   id = "lc_mos_2_action",
				   next = "lc_mos_end_2",
				   action = mos_prio,
				   )

	 BinaryCondition(
					 id = "lc_mos_3",
					 condition = move_mos_cond,
					 next_true = "lc_mos_3_yes",
					 next_false = "lc_mos_end_3",
					 )
	 UseActiveDie(
				  id = "lc_mos_3_yes",
				  next = "lc_mos_3_action",
				  )
	 PerformAction(
				   id = "lc_mos_3_action",
				   next = "lc_mos_end_3",
				   action = mos_prio,
				   )

	 BinaryCondition(
					 id = "lc_mos_4",
					 condition = move_mos_cond,
					 next_true = "lc_mos_4_yes",
					 next_false = "lc_mos_end_4",
					 )
	 UseActiveDie(
				  id = "lc_mos_4_yes",
				  next = "lc_mos_4_action",
				  )
	 PerformAction(
				   id = "lc_mos_4_action",
				   next = "lc_mos_end_4",
				   action = mos_prio,
				   )

	 EndNode(id = "lc_mos_end_1")
	 EndNode(id = "lc_mos_end_2")
	 EndNode(id = "lc_mos_end_3")
	 EndNode(id = "lc_mos_end_4")


	 ########################################
	 JumpToGraph(
				 id = "lc_play_card",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "lc_play_card_return",
				 )
	 ReturnFromGraph(
					 id = "lc_play_card_return",
					 )


	 ################################################################################
	 StartNode(
			   id = "character_wk_prio",
			   text = "Character:\n Witch King Priority",
			   next = "lc_wk_prio",
			   )
	 PerformAction(
				   id = "lc_wk_prio",
				   next = "lc_wk_prio_end",
				   action = wk_prio,
				   )
	 EndNode(id = "lc_wk_prio_end")


	 ################################################################################
	 StartNode(
			   id = "character_nazgul_prio",
			   text = "Character:\n Nazgûl Priority",
			   next = "lc_nazgul_prio",
			   )
	 PerformAction(
				   id = "lc_nazgul_prio",
				   next = "lc_nazgul_prio_end",
				   action = wk_prio,
				   )
	 EndNode(id = "lc_nazgul_prio_end")


	 ################################################################################
	 StartNode(
			   id = "character_mos_prio",
			   text = "Character:\n Mouth of Sauron Priority",
			   next = "lc_mos_prio",
			   )
	 PerformAction(
				   id = "lc_mos_prio",
				   next = "lc_mos_prio_end",
				   action = wk_prio,
				   )
	 EndNode(id = "lc_mos_prio_end")
	 ]
end
