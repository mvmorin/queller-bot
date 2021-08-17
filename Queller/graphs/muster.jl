let
	minion_prio = """
	Select a minion that can be reqruited.

	Priority:
	1. Saruman
	2. Witch King
	3. Mouth of Sauron
	"""

	recruit_saruman = """
	Recruit Saruman.
	"""

	recruit_wk = """
	Recruit the Witch King, place it in a valid region according to the following priority.

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

	recruit_mos = """
	Recruit Mouth of Sauron, place it in a valid region according to the following priority.

	1. Army than is conducting a siege.
	2. A *mobile* army
	3. Army becomes mobile if Mouth of Sauron is added
	4. Army that contains Saruman
	5. Army with the highest *value*
	6. Stronghold closest to army whose *target* is in a nation at war
	7. Stronghold closest to army whose *target* is in an active nation
	8. Stronghold closest to army whose *target* is in a passive nation
	9. Random
	"""


	[
	 ################################################################################
	 StartNode(
			   id = "muster_minion",
			   text = "Muster: Minion",
			   next = "m_2_reserved_check",
			   )
	 BinaryCondition(
					 id = "m_2_reserved_check",
					 next_true = "m_2_return",
					 next_false = "m_2",
					 condition = """
					 A die has been reserved for recruiting a minion as a last action.
					 """,
					 )
	 BinaryCondition(
					 id = "m_2",
					 condition = """
					 Minion can be recruited.
					 """,
					 next_true = "m_2_1",
					 next_false = "m_2_return",
					 )
	 ReturnFromGraph(
					 id = "m_2_return",
					 )
	 BinaryCondition(
					 id = "m_2_1",
					 condition = """
					 The Free Peoples' have a Will of the West die.
					 And, Gandalf the White has not been recruited.
					 And, no minion have been recruited.
					 """,
					 next_true = "m_2_1_yes",
					 next_false = "m_2_minion_selection",
					 )
	 UseActiveDie(
				  id = "m_2_1_yes",
				  next = "m_2_1_reserve",
				  )
	 PerformAction(
				   id = "m_2_1_reserve",
				   next = "m_2_1_return",
				   action = """
				   Set aside the die (and ring if necessary). Use this die as an last action to recruit a minion. Minion selection and placement can be made from the main menu.
				   """,
				   )
	 ReturnFromGraph(
					 id = "m_2_1_return",
					 )

	 MultipleChoice(
					id = "m_2_minion_selection",
					conditions = minion_prio,
					nexts = [
							 "m_2_saruman_die",
							 "m_2_wk_die",
							 "m_2_mos_die",
							 ]
					)
	 UseActiveDie(
				  id = "m_2_saruman_die",
				  next = "m_2_saruman_placement",
				  )
	 PerformAction(
				   id = "m_2_saruman_placement",
				   next = "m_2_saruman_end",
				   action = recruit_saruman,
				   )
	 UseActiveDie(
				  id = "m_2_wk_die",
				  next = "m_2_wk_placement",
				  )
	 PerformAction(
				   id = "m_2_wk_placement",
				   next = "m_2_wk_end",
				   action = recruit_wk,
				   )
	 UseActiveDie(
				  id = "m_2_mos_die",
				  next = "m_2_mos_placement",
				  )
	 PerformAction(
				   id = "m_2_mos_placement",
				   next = "m_2_mos_end",
				   action = recruit_mos,
				   )
	 EndNode(id = "m_2_saruman_end")
	 EndNode(id = "m_2_wk_end")
	 EndNode(id = "m_2_mos_end")


	 ################################################################################
	 StartNode(
			   id = "muster_minion_selection",
			   text = "Muster: Minion Selectoin",
			   next = "m_2_minion_selection_last",
			   )
	 MultipleChoice(
					id = "m_2_minion_selection_last",
					conditions = minion_prio,
					nexts = [
							 "m_2_saruman_last",
							 "m_2_wk_last",
							 "m_2_mos_last",
							 ]
					)
	 PerformAction(
				   id = "m_2_saruman_last",
				   next = "m_2_saruman_end_last",
				   action = recruit_saruman,
				   )
	 PerformAction(
				   id = "m_2_wk_last",
				   next = "m_2_wk_end_last",
				   action = recruit_wk,
				   )
	 PerformAction(
				   id = "m_2_mos_last",
				   next = "m_2_mos_end_last",
				   action = recruit_mos,
				   )
	 EndNode(id = "m_2_saruman_end_last")
	 EndNode(id = "m_2_wk_end_last")
	 EndNode(id = "m_2_mos_end_last")



	 ################################################################################
	 StartNode(
			   id = "muster_politics",
			   text = "Muster: Politics",
			   next = "m_3",
			   )
	 BinaryCondition(
					 id = "m_3",
					 condition = """
					 A Shadow nation is not at war.
					 """,
					 next_true = "m_3_yes",
					 next_false = "m_3_return",
					 )
	 ReturnFromGraph(
					 id = "m_3_return",
					 )
	 UseActiveDie(
				  id = "m_3_yes",
				  next = "m_3_action",
				  )
	 PerformAction(
				   id = "m_3_action",
				   next = "m_3_end",
				   action = """
				   Move a nation down one step on the political track.

				   Priority:
				   1. Isengard
				   2. Sauron
				   3. Southrons and Easterlings
				   """
				   )
	 EndNode(id = "m_3_end")





	 ################################################################################
	 StartNode(
			   id = "muster_muster",
			   text = "Muster: Muster",
			   next = "m_4",
			   )
	 BinaryCondition(
					 id = "m_4",
					 condition = """
					 A card that musters is "playable".
					 """,
					 next_true = "m_4_die",
					 next_false = "m_5",
					 )
	 UseActiveDie(
				  id = "m_4_die",
				  next = "m_4_action",
				  )
	 PerformAction(
				   id = "m_4_action",
				   next = "m_4_end",
				   action = """
				   Play a *playable* muster card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """
				   )
	 EndNode(id = "m_4_end")

	 BinaryCondition(
					 id = "m_5",
					 condition = """
					 Muster is possible.
					 """,
					 next_true = "m_6",
					 next_false = "m_return",
					 )
	 ReturnFromGraph(
					 id = "m_return",
					 )

	 BinaryCondition(
					 id = "m_6",
					 condition = """
					 Muster can create an *exposed* region.
					 """,
					 next_true = "m_6_die",
					 next_false = "m_7",
					 )
	 UseActiveDie(
				  id = "m_6_die",
				  next = "m_6_action",
				  )
	 PerformAction(
				   id = "m_6_action",
				   next = "m_6_end",
				   action = """
				   *Focus* priority:
				   1. Region which creates an *exposed* region
				   2. Random

				   Muster:
				   *Primary*: Elite
				   *Secondary*: Regular

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_6_end")


	 BinaryCondition(
					 id = "m_7",
					 condition = """
					 The Fellowship is adjacent to, or in, a region it is possible to muster in.
					 And, the progress put the Fellowship outside Mordor.
					 And, no army is adjacent to the Fellowship's current region.
					 """,
					 next_true = "m_7_die",
					 next_false = "m_8",
					 )
	 UseActiveDie(
				  id = "m_7_die",
				  next = "m_7_action",
				  )
	 PerformAction(
				   id = "m_7_action",
				   next = "m_7_end",
				   action = """
				   *Focus* priority:
				   1. The Fellowship's current region

				   Muster:
				   *Primary*: Regular
				   *Secondary*: Nazgûl

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_7_end")


	 BinaryCondition(
					 id = "m_8",
					 condition = """
					 Muster is possible in a region containing a Shadow army.
					 """,
					 next_true = "m_8_die",
					 next_false = "m_9",
					 )
	 UseActiveDie(
				  id = "m_8_die",
				  next = "m_8_action",
				  )
	 PerformAction(
				   id = "m_8_action",
				   next = "m_8_end",
				   action = """
				   *Focus* priority:
				   1. Army is *mobile*
				   2. Army's *target* is a nation at war
				   3. Army becomes mobile if the Witch King is added
				   4. Opposing army does not contain Gandalf the White
				   5. Army with the highest *value*
				   6. Random

				   Muster:
				   *Primary*: Regular
				   *Secondary*: Nazgûl

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_8_end")


	 BinaryCondition(
					 id = "m_9",
					 condition = """
					 Less than 6 Nazgûl in play.
					 """,
					 next_true = "m_10_yes",
					 next_false = "m_10_no",
					 )
	 UseActiveDie(
				  id = "m_10_yes",
				  next = "m_10_yes_action",
				  )
	 PerformAction(
				   id = "m_10_yes_action",
				   next = "m_10_end_yes",
				   action = """
				   *Focus* priority:
				   1. Closest to army whose *target* is in a nation at war
				   2. Closest to army whose *target* is in an active nation.
				   3. Closest to a *mobile* army
				   4. Closest to army whose *target* is in a passive nation.
				   5. Random

				   Muster:
				   *Primary*: Nazgûl
				   *Secondary*: Nazgûl

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_10_end_yes")
	 UseActiveDie(
				  id = "m_10_no",
				  next = "m_10_no_action",
				  )
	 PerformAction(
				   id = "m_10_no_action",
				   next = "m_10_end_no",
				   action = """
				   *Focus* priority:
				   1. Closest to army whose *target* is in a nation at war
				   2. Closest to army whose *target* is in an active nation.
				   3. Closest to a *mobile* army
				   4. Closest to army whose *target* is in a passive nation.
				   5. Random

				   Muster:
				   *Primary*: Elite
				   *Secondary*: Nazgûl

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_10_end_no")




	 ################################################################################

	 StartNode(
			   id = "muster_card",
			   text = "Muster: Card",
			   next = "m_c_6",
			   )
	 BinaryCondition(
					 id = "m_c_6",
					 condition = """
					 Muster can create an *exposed* region.
					 """,
					 next_true = "m_c_6_action",
					 next_false = "m_c_7",
					 )
	 PerformAction(
				   id = "m_c_6_action",
				   next = "m_c_6_end",
				   action = """
				   *Focus* priority:
				   1. Region which creates an *exposed* region
				   2. Random

				   Muster:
				   *Primary*: Units according to card
				   *Secondary*: Units according to card
				   """
				   )
	 EndNode(id = "m_c_6_end")


	 BinaryCondition(
					 id = "m_c_7",
					 condition = """
					 The Fellowship is adjacent to, or in, a region it is possible to muster in.
					 And, the progress put the Fellowship outside Mordor.
					 And, no army is adjacent to the Fellowship's current region.
					 """,
					 next_true = "m_c_7_action",
					 next_false = "m_c_8",
					 )
	 PerformAction(
				   id = "m_c_7_action",
				   next = "m_c_7_end",
				   action = """
				   *Focus* priority:
				   1. The Fellowship's current region

				   Muster:
				   *Primary*: Units according to card
				   *Secondary*: Units according to card
				   """
				   )
	 EndNode(id = "m_c_7_end")


	 BinaryCondition(
					 id = "m_c_8",
					 condition = """
					 Muster is possible in a region containing a Shadow army.
					 """,
					 next_true = "m_c_8_action",
					 next_false = "m_c_9",
					 )
	 PerformAction(
				   id = "m_c_8_action",
				   next = "m_c_8_end",
				   action = """
				   *Focus* priority:
				   1. Army is *mobile*
				   2. Army's *target* is a nation at war
				   3. Army becomes mobile if the Witch King is added
				   4. Opposing army does not contain Gandalf the White
				   5. Army with the highest *value*
				   6. Random

				   Muster:
				   *Primary*: Units according to card
				   *Secondary*: Units according to card
				   """
				   )
	 EndNode(id = "m_c_8_end")


	 PerformAction(
				   id = "m_c_9",
				   next = "m_c_9_end",
				   action = """
				   *Focus* priority:
				   1. Closest to army whose *target* is in a nation at war
				   2. Closest to army whose *target* is in an active nation.
				   3. Closest to a *mobile* army
				   4. Closest to army whose *target* is in a passive nation.
				   5. Random

				   Muster:
				   *Primary*: Units according to card
				   *Secondary*: Units according to card
				   """
				   )
	 EndNode(id = "m_c_9_end")


	 ]
end
