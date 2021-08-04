let
	[
	 StartNode(
			   id = "leader_character_movement",
			   text = "Leaders and Characters:\n Movements and Attacks",
			   next = "lc_1",
			   )

	 YesNoCondition(
					id = "lc_1",
					condition = """
					Is there an *aggressive* army
					adjacent to its *target* and
					it has the Witch King or maximum
					leadership?
					""",
					next_yes = "lc_1_yes",
					next_no = "lc_2",
					)
	 UseActiveDie(
				  id = "lc_1_yes",
				  next = "lc_1_action",
				  )
	 PerformAction(
				   id = "lc_1_action",
				   next = "lc_1_end",
				   action = """
				   Attack with the army
				   """
				   )
	 EndNode(id = "lc_1_end")

	 YesNoCondition(
					id = "lc_2",
					condition = """
					Is there a *mobile* army with
					leadership and a valid move/attack
					towardrs closest *target*?
					""",
					next_yes = "lc_2_yes",
					next_no = "lc_3",
					)
	 JumpToGraph(
				 id = "lc_2_yes",
				 text = "Movement and Attack:\n Basic",
				 jump_graph = "movement_attack_basic",
				 next = "lc_3",
				 )




	 StartNode(
			   id = "leader_character_leaders",
			   text = "Leaders and Characters:\n Leaders",
			   next = "lc_3",
			   )
	 YesNoCondition(
					id = "lc_3",
					condition = """
					Is a Nazgûl or the Witch King
					in play?
					""",
					next_yes = "lc_4",
					next_no = "lc_3_no",
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



	 YesNoCondition(
					id = "lc_4",
					condition = """
					Is the Witch King not in an *mobile*
					army but is able to join or create one?
					""",
					next_yes = "lc_4_yes",
 					next_no = "lc_5",
					)
	 UseActiveDie(
				  id = "lc_4_yes",
				  next = "lc_4_action",
				  )
	 PerformAction(
				   id = "lc_4_action",
				   next = "lc_5",
				   action = """
				   Move the Witch King, place
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
					id = "lc_5",
					condition = """
					Is there no Nazgûl in the Fellowship's
					region but they are able to move there?
					Or, can a Nazgûl join or create a *mobile*
					army that currently have no Nazgûl?
					""",
					next_yes = "lc_5_yes",
 					next_no = "lc_6",
					)
	 UseActiveDie(
				  id = "lc_5_yes",
				  next = "lc_5_action",
				  )
	 PerformAction(
				   id = "lc_5_action",
				   next = "lc_6",
				   action = """
				   Gather all Nazgûl and place them one
				   at the time according to the following
				   priority.

				   1. One, and only one, in the Fellowship's
				      region
				   2. Army with leadership value less than
				      the number of army units and 5
				   3. Army which contain the Which King
				   4. Shadow stronghold under siege
				   5. *Mobile* army
				   6. Army adjacent to *threat*
				   7. Army whose *target* nation is active
				   8. Army that becomes *mobile* if Nazgûl
				      is added
				   9. Army not sieging
				   10. Army that is adjacent to its *target*
				   11. Highest *value* shadow army
				   """
				   )

	 YesNoCondition(
					id = "lc_6",
					condition = """
					Is Mouth of Souron not in a *mobile*
					army?
					""",
					next_yes = "lc_6_yes",
 					next_no = "lc_7",
					)
	 UseActiveDie(
				  id = "lc_6_yes",
				  next = "lc_6_action",
				  )
	 PerformAction(
				   id = "lc_6_action",
				   next = "lc_7",
				   action = """
				   Move Mouth of Sauron

				   Priority:
				   1. Army with leadership value less than
				   the number of army units and 5
				   2. *Mobile* army
				   3. Army adjacent to its *target*
				   4. Army which can be reach with this die
				   5. Closest army
				   """
				   )
	 DieHasBeenUsed(
					id = "lc_7",
					next_used = "lc_7_end",
					next_not_used = "lc_8"
					)
	 EndNode(id = "lc_7_end")
	 JumpToGraph(
				 id = "lc_8",
				 text = "Event Cards: Preferred",
				 jump_graph = "event_cards_preferred",
				 next = "lc_8_return",
				 )
	 ReturnFromGraph(
					 id = "lc_8_return",
					 )



	 ]
end
