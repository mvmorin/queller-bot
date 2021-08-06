let
	[
################################################################################
	 StartNode(
			   id = "muster_minion",
			   text = "Muster: Minion",
			   next = "m_2_reserved_check",
			   )
	 IsDieReserved(
				   id = "m_2_reserved_check",
				   next_yes = "m_2_return",
				   next_no = "m_2",
				   )
	 YesNoCondition(
					id = "m_2",
					condition = """
					Minion can be recruited.
					""",
					next_yes = "m_2_1",
					next_no = "m_2_return",
					)
	 ReturnFromGraph(
					 id = "m_2_return",
					 )
	 YesNoCondition(
					id = "m_2_1",
					condition = """
					The Free Peoples' have a Will of the West die.
					And, Gandalf the White has not been recruited.
					And, no minion have been recruited.
					""",
					next_yes = "m_2_1_yes",
					next_no = "m_2_1_no",
					)
	 ReserveDie(
				id = "m_2_1_yes",
				next = "m_2_1_return",
				)
	 ReturnFromGraph(
					 id = "m_2_1_return",
					 )

	 PerformAction(
				   id = "m_2_1_no",
				   next = "m_2_wk",
				   action = """
				   Select a minion that can be reqruited.

				   Priority:
				   1. Saruman
				   2. Witch King
				   3. Mouth of Sauron
				   """
				   )
	 YesNoCondition(
					id = "m_2_wk",
					condition = """
					The Witch King was selected.
					""",
					next_yes = "m_2_wk_die",
					next_no = "m_2_mos",
					)
	 UseActiveDie(
				  id = "m_2_wk_die",
				  next = "m_2_wk_placement",
				  )
	 PerformAction(
				   id = "m_2_wk_placement",
				   next = "m_2_wk_end",
				   action = """
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
				   )
	 YesNoCondition(
					id = "m_2_mos",
					condition = """
					Mouth of Sauron was selected.
					""",
					next_yes = "m_2_mos_die",
					next_no = "m_2_mos_end",
					)
	 UseActiveDie(
				  id = "m_2_mos_die",
				  next = "m_2_mos_placement",
				  )
	 PerformAction(
				   id = "m_2_mos_placement",
				   next = "m_2_mos_end",
				   action = """
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
				   )
	 EndNode(id = "m_2_wk_end")
	 EndNode(id = "m_2_mos_end")





################################################################################
	 StartNode(
			   id = "muster_politics",
			   text = "Muster: Politics",
			   next = "m_3",
			   )
	 YesNoCondition(
					id = "m_3",
					condition = """
					A Shadow nation is not at war.
					""",
					next_yes = "m_3_yes",
					next_no = "m_3_return",
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
	 YesNoCondition(
					id = "m_4",
					condition = """
					A card that musters is "playable".
					""",
					next_yes = "m_4_die",
					next_no = "m_5",
					)
	 UseActiveDie(
				  id = "m_4_die",
				  next = "m_4_action",
				  )
	 PerformAction(
				   id = "m_4_action",
				   next = "m_4_resolve",
				   action = """
				   Play a *playable* muster card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """
				   )
	 JumpToGraph(
				 id = "m_4_resolve",
				 text = "Event Cards: Resolution",
				 next = "m_4_end",
				 jump_graph = "event_cards_resolution",
				 )
	 EndNode(id = "m_4_end")

	 YesNoCondition(
					id = "m_5",
					condition = """
					Muster is possible.
					""",
					next_yes = "m_muster_position",
					next_no = "m_return",
					)
	 JumpToGraph(
				 id = "m_muster_position",
				 text = "Muster: Region",
				 next = "m_5_end",
				 jump_graph = "event_cards_resolution",
				 )
	 ReturnFromGraph(
					 id = "m_return",
					 )
	 EndNode(id = "m_5_end")




	 StartNode(
			   id = "muster_region",
			   text = "Muster: Region",
			   next = "m_6_1",
			   )
	 YesNoCondition(
					id = "m_6_1",
					condition = """
					Muster can create an *exposed* *target*.
					""",
					next_yes = "m_6_die",
					next_no = "m_7",
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
				   1. Region which creates an *exposed* *target*
				   2. Random

				   Muster:
				   *Primary*: Elite
				   *Secondary*: Regular

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 ReturnFromGraph(id = "m_6_end")


	 YesNoCondition(
					id = "m_7",
					condition = """
					The Fellowship is adjacent to a Shadow settlement.
					And, the progress put the Fellowship outside Mordor.
					And, no army is adjacent to the Fellowship's current region.
					""",
					next_yes = "m_7_die",
					next_no = "m_8",
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
				   1. Fellowship's current region

				   Muster:
				   *Primary*: Regular
				   *Secondary*: Nazgûl

				   If unit is unavailable, rotate as:
				   Elite -> Regular -> Nazgûl -> Elite
				   """
				   )
	 ReturnFromGraph(id = "m_7_end")


	 YesNoCondition(
					id = "m_8",
					condition = """
					Muster is possible in a region containing a Shadow army.
					""",
					next_yes = "m_8_die",
					next_no = "m_9",
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
	 ReturnFromGraph(id = "m_8_end")


	 YesNoCondition(
					id = "m_9",
					condition = """
					Less than 6 Nazgûl in play.
					""",
					next_yes = "m_10_yes",
					next_no = "m_10_no",
					)
	 UseActiveDie(
				  id = "m_10_yes",
				  next = "m_10_yes_action",
				  )
	 PerformAction(
				   id = "m_10_yes_action",
				   next = "m_10_end",
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
	 UseActiveDie(
				  id = "m_10_no",
				  next = "m_10_no_action",
				  )
	 PerformAction(
				   id = "m_10_no_action",
				   next = "m_10_end",
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
	 ReturnFromGraph(id = "m_10_end")

	 ]
end
