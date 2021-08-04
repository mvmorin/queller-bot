let
	[
	 StartNode(
			   id = "mustering_threat",
			   text = "Mustering: Threat",
			   next = "m_1",
			   )

	 YesNoCondition(
					id = "m_1",
					condition = """
					Is a stronghold under
					*threat* and is it a
					valid muster region?
					""",
					next_yes = "m_1_yes",
					next_no = "m_2",
					)
	 UseActiveDie(
				  id = "m_1_yes",
				  next = "m_1_action",
				  )
	 PerformAction(
				   id = "m_1_action",
				   next = "m_1_end",
				   action = """
				   Muster as follows:

				   *Primary*: Elite
				   *Secondary*: Regular

				   If units are unavailable,
				   rotate as follows.

				   Elite -> Regular
				   Regular -> Nazgûl
				   Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_1_end")







	 StartNode(
			   id = "mustering_minion",
			   text = "Mustering: Minion",
			   next = "m_2",
			   )
	 YesNoCondition(
					id = "m_2",
					condition = """
					Is any condition to muster
					a minion met?
					""",
					next_yes = "m_2_1",
					next_no = "m_3",
					)
	 YesNoCondition(
					id = "m_2_1",
					condition = """
					Does the FP have a Will of the West
					die and Gandalf the White has not
					been recruited and no minions have
					been recruited?
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
				   Select a minion that is
				   possible to reqruit.

				   Priority:
				   1. Saruman
				   2. Witch King
				   3. Mouth of Sauron
				   """
				   )
	 YesNoCondition(
					id = "m_2_wk",
					condition = """
					Was the Witch King selected?
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
				   Recruit the Witch King, place
				   it in a valid region according
				   to the following priority.

				   1. Army is *mobile*
				   2. *Target* nation is at war
				   3. Army becomes mobile if the
				      Witch King is added
				   4. Opposing army does not
				      contain Gandalf the White
				   5. Opposing army does not
				      contain hobbits
				   6. Adjacent to *threat*
				   7. Army that is conduction a
				      siege
				   8. Army adjacent to its *target*
				   9. Highest *value* Shadow army.
				   """
				   )
	 YesNoCondition(
					id = "m_2_mos",
					condition = """
					Was Mouth of Sauron selected?
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
				   Recruit Mouth of Sauron, place
				   it in a valid region according
				   to the following priority.

				   1. Army than is conducting a
				      siege.
				   2. A *mobile* army
				   3. Army becomes mobile if
				      Mouth of Sauron is added
				   4. Army that contains Saruman
				   5. Army with the highest *value*
				   6. Stronhold closest to army whose
				      *target* is in a nation at war
				   7. Stronhold closest to army whose
				      *target* is in an active nation
				   8. Stronhold closest to army whose
				      *target* is in a passive nation
				   """
				   )
	 EndNode(id = "m_2_wk_end")
	 EndNode(id = "m_2_mos_end")





	 YesNoCondition(
					id = "m_3",
					condition = """
					Is any shadow nation not
					at war?
					""",
					next_yes = "m_3_yes",
					next_no = "m_4",
					)
	 UseActiveDie(
				  id = "m_3_yes",
				  next = "m_3_action",
				  )
	 PerformAction(
				   id = "m_3_action",
				   next = "m_3_end",
				   action = """
				   Move a nation down one step
				   the political track.

				   Priority:
				   1. Isengard
				   2. Sauron
				   3. Southrons and Easterlings
				   """
				   )
	 EndNode(id = "m_3_end")





	 StartNode(
			   id = "mustering_muster",
			   text = "Mustering: Muster",
			   next = "m_4",
			   )
	 StartNode(
			   id = "mustering_card",
			   text = "Mustering: Card",
			   next = "m_4_2",
			   )

	 YesNoCondition(
					id = "m_4",
					condition = """
					Is SP holding a playable
					muster card.
					""",
					next_yes = "m_4_1",
					next_no = "m_5",
					)
	 PerformAction(
				   id = "m_4_1",
				   next = "m_4_2",
				   action = """
				   Select a playable muster
				   card at random
				   """
				   )
	 YesNoCondition(
					id = "m_4_2",
					condition = """
					Does the selected card allow
					choice in the muster location?
					""",
					next_yes = "m_5_1",
					next_no = "m_4_die",
					)
	 UseActiveDie(
				  id = "m_4_die",
				  next = "m_4_action",
				  )
	 PerformAction(
				   id = "m_4_action",
				   next = "m_4_end",
				   action = """
				   Play the selected card.
				   """
				   )
	 EndNode(id = "m_4_end")





	 YesNoCondition(
					id = "m_5",
					condition = """
					Is SP able to muster?
					""",
					next_yes = "m_5_1",
					next_no = "m_return",
					)
	 ReturnFromGraph(
					 id = "m_return",
					 )
	 YesNoCondition(
					id = "m_5_1",
					condition = """
					Can an *exposed* *target*
					be created with a muster?
					""",
					next_yes = "m_5_die",
					next_no = "m_6",
					)
	 UseActiveDie(
				  id = "m_5_die",
				  next = "m_5_action",
				  )
	 PerformAction(
				   id = "m_5_action",
				   next = "m_5_end",
				   action = """
				   Muster as follows:

				   *Primary*: Elite
				   *Secondary*: Regular

				   If units are unavailable,
				   rotate as follows.

				   Elite -> Regular
				   Regular -> Nazgûl
				   Nazgûl -> Elite
				   """
				   )
	 EndNode(id = "m_5_end")


	 YesNoCondition(
					id = "m_6",
					condition = """
					Is the Fellowship adjacent
					to a Shadow Settlement and
					its progress puts it outside
					Mordor and no army is in or
					adjacent to its current
					region?
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
				   Muster as follows:

				   *Primary*: Regular
				   *Secondary*: Nazgûl

				   If units are unavailable,
				   rotate as follows.

				   Regular -> Nazgûl
				   Nazgûl -> Elite
				   Elite -> Regular
				   """
				   )
	 EndNode(id = "m_6_end")


	 YesNoCondition(
					id = "m_7",
					condition = """
					Is it possible to muster
					in a region containing a
					Shadow army?
					""",
					next_yes = "m_7_select",
					next_no = "m_8",
					)
	 PerformAction(
				   id = "m_7_select",
				   next = "m_7_die",
				   action = """
				   Select a possible muster
				   army with the following
				   priority.

				   1. Army is *mobile*
				   2. *Target* nation is at war
				   3. Army becomes mobile if the
				      Witch King is added
				   4. Opposing army does not
				      contain Gandalf the White
				   5. Army with the highest
				      *value*
				   """
				   )
	 UseActiveDie(
				  id = "m_7_die",
				  next = "m_7_action",
				  )
	 PerformAction(
				   id = "m_7_action",
				   next = "m_7_end",
				   action = """
				   Muster as follows:

				   *Primary*: Regular
				   *Secondary*: Nazgûl

				   If units are unavailable,
				   rotate as follows.

				   Regular -> Nazgûl
				   Nazgûl -> Elite
				   Elite -> Regular
				   """
				   )
	 EndNode(id = "m_7_end")


	 PerformAction(
				   id = "m_8",
				   next = "m_9",
				   action = """
				   Select a possible muster
				   settlement with the following
				   priority.

				   1. Closest to army whose *target*
				      is in a nation at war
				   2. Closest to army whose *target*
				      is in an active nation.
				   3. Closest to a *mobile* army
				   4. Closest to army whose *target*
				      is in a passive nation.

				   """
				   )
	 YesNoCondition(
					id = "m_9",
					condition = """
					Is there less than 6
					Nazgûl in play?
					""",
					next_yes = "m_9_yes",
					next_no = "m_9_no",
					)
	 UseActiveDie(
				  id = "m_9_yes",
				  next = "m_9_yes_action",
				  )
	 PerformAction(
				   id = "m_9_yes_action",
				   next = "m_9_end",
				   action = """
				   Muster as follows:

				   *Primary*: Nazgûl
				   *Secondary*: Nazgûl

				   If units are unavailable,
				   rotate as follows.

				   Regular -> Nazgûl
				   Nazgûl -> Elite
				   Elite -> Regular
				   """
				   )
	 UseActiveDie(
				  id = "m_9_no",
				  next = "m_9_no_action",
				  )
	 PerformAction(
				   id = "m_9_no_action",
				   next = "m_9_end",
				   action = """
				   Muster as follows:

				   *Primary*: Elite
				   *Secondary*: Nazgûl

				   If units are unavailable,
				   rotate as follows.

				   Regular -> Nazgûl
				   Nazgûl -> Elite
				   Elite -> Regular
				   """
				   )
	 EndNode(id = "m_9_end")










	 ]
end
