let
	[
	 StartNode(
			   id = "movement_attack_threat_exposed",
			   text = "Movement and Attack:\n Threat or Exposed",
			   next = "mv_tx_t",
			   )

	 YesNoCondition(
					id = "mv_tx_t",
					condition = """
					Does a *threat* exist?
					""",
					next_yes = "mv_tx_1",
					next_no = "mv_tx_5",
					)

	 YesNoCondition(
					id = "mv_tx_1",
					condition = """
					Is there a *mobile* army
					adjacent to a *threat*?
					""",
					next_yes = "mv_tx_1_yes",
					next_no = "mv_tx_2",
					)
	 UseActiveDie(
				  id = "mv_tx_1_yes",
				  next = "mv_tx_1_action",
				  )
	 PerformAction(
				   id = "mv_tx_1_action",
				   next = "mv_tx_1_end",
				   action = """
				   Attack *threat* with
				   adjacent *mobile* army.
				   """
				   )
	 EndNode(id = "mv_tx_1_end")


	 YesNoCondition(
					id = "mv_tx_2",
					condition = """
					Is it possible to move a
					*mobile* army adjacent to
					*threat*?
					""",
					next_yes = "mv_tx_2_yes",
					next_no = "mv_tx_3",
					)
	 UseActiveDie(
				  id = "mv_tx_2_yes",
				  next = "mv_tx_2_action",
				  )
	 PerformAction(
				   id = "mv_tx_2_action",
				   next = "mv_tx_2_movement_remains",
				   action = """
				   Move *mobile* army
				   adjacent to *threat*.
				   """
				   )
	 YesNoCondition(
					id = "mv_tx_2_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_tx_2",
					next_no = "mv_tx_2_end",
					)
	 EndNode(id = "mv_tx_2_end")

	 YesNoCondition(
					id = "mv_tx_3",
					condition = """
					Is it possible to move an
					army to increase valuse at
					*threatened* stronghold?
					""",
					next_yes = "mv_tx_3_yes",
					next_no = "mv_tx_4",
					)
	 UseActiveDie(
				  id = "mv_tx_3_yes",
				  next = "mv_tx_3_action",
				  )
	 PerformAction(
				   id = "mv_tx_3_action",
				   next = "mv_tx_3_movement_remains",
				   action = """
				   Move army to *threatened*
				   stronghold.
				   """
				   )
	 YesNoCondition(
					id = "mv_tx_3_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_tx_3",
					next_no = "mv_tx_3_end",
					)
	 EndNode(id = "mv_tx_3_end")


	 YesNoCondition(
					id = "mv_tx_4",
					condition = """
					Would moving a *mobile*
					army towards its closest
					*target* take is closer
					to the *threat*?
					""",
					next_yes = "mv_tx_4_yes",
					next_no = "mv_tx_5",
					)
	 UseActiveDie(
				  id = "mv_tx_4_yes",
				  next = "mv_tx_4_action",
				  )
	 PerformAction(
				   id = "mv_tx_4_action",
				   next = "mv_tx_4_movement_remains",
				   action = """
				   Move *mobile* army towards
				   closest *target* such that
				   it moves closer to *threat*.
				   """
				   )
	 YesNoCondition(
					id = "mv_tx_4_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_tx_4",
					next_no = "mv_tx_4_end",
					)
	 EndNode(id = "mv_tx_4_end")


	 YesNoCondition(
					id = "mv_tx_5",
					condition = """
					Does an *exposed* target
					exists and can an army
					move towards it?
					""",
					next_yes = "mv_tx_5_yes",
					next_no = "mv_tx_return",
					)
	 ReturnFromGraph(
					 id = "mv_tx_return"
					 )
	 UseActiveDie(
				  id = "mv_tx_5_yes",
				  next = "mv_tx_5_action",
				  )
	 PerformAction(
				   id = "mv_tx_5_action",
				   next = "mv_tx_5_movement_remains",
				   action = """
				   Move army towards *exposed*
				   target.
				   """
				   )
	 YesNoCondition(
					id = "mv_tx_5_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_tx_5",
					next_no = "mv_tx_5_end",
					)
	 EndNode(id = "mv_tx_5_end")










	 StartNode(
			   id = "movement_attack_besiege",
			   text = "Movement and Attack:\n Besiege",
			   next = "mv_1",
			   )

	 YesNoCondition(
					id = "mv_1",
					condition = """
					Is a *mobile* army adjacent
					to *target* that is not under
					siege?
					""",
					next_yes = "mv_1_yes",
					next_no = "mv_2",
					)
	 UseActiveDie(
				  id = "mv_1_yes",
				  next = "mv_1_action",
				  )
	 PerformAction(
				   id = "mv_1_action",
				   next = "mv_1_end",
				   action = """
				   Attack with army with adjacent
				   *target* not under siege.

				   Priority:
				   1. Army whose *target* is in
				   a nation at war
				   2. Army whose attack would not
				   put a nation at war.
				   3. Army whose *target* is in
				   an active nation
				   4. Highest value shadow army
				   """
				   )
	 EndNode(id = "mv_1_end")

	 StartNode(
			   id = "movement_attack_corr",
			   text = "Movement and Attack:\n Corruption",
			   next = "mv_2",
			   )
	 YesNoCondition(
					id = "mv_2",
					condition = """
					Is there dice in the hunt pool, and,
					no army in the fellowship's	region,
					and, an army can move into that
					region without increasing the
					distance to its *target*?
					""",
					next_yes = "mv_2_yes",
					next_no = "mv_3",
					)
	 UseActiveDie(
				  id = "mv_2_yes",
				  next = "mv_2_action",
				  )
	 PerformAction(
				   id = "mv_2_action",
				   next = "mv_2_movement_remains",
				   action = """
				   Move army into the fellowship's
				   region without increasing the
				   distance to its target.
				   """
				   )
	 YesNoCondition(
					id = "mv_2_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_2",
					next_no = "mv_2_end",
					)
	 EndNode(id = "mv_2_end")





	 StartNode(
			   id = "movement_attack_card",
			   text = "Movement and Attack:\n Card",
			   next = "mv_3",
			   )

	 YesNoCondition(
					id = "mv_3",
					condition = """
					Can an army move into an emtpy
					settlement of a nation at war?
					""",
					next_yes = "mv_3_1",
					next_no = "mv_4",
					)
	 YesNoCondition(
					id = "mv_3_1",
					condition = """
					Can an army move into an empty
					settlement of a nation at war
					without increasing the distance
					to its *target*?
					""",
					next_yes = "mv_3_yes",
					next_no = "mv_3_no",
					)
	 UseActiveDie(
				  id = "mv_3_yes",
				  next = "mv_3_yes_action",
				  )
	 PerformAction(
				   id = "mv_3_yes_action",
				   next = "mv_3_movement_remains",
				   action = """
				   Move army into empty settlement
				   of nation at war without increasing
				   the distance to the target.
				   """
				   )
	 UseActiveDie(
				  id = "mv_3_no",
				  next = "mv_3_no_action",
				  )
	 PerformAction(
				   id = "mv_3_no_action",
				   next = "mv_3_movement_remains",
				   action = """
				   Move 1 unit into empty settlement
				   of nation at war without increasing
				   the distance to the target.
				   """
				   )
	 YesNoCondition(
					id = "mv_3_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_3",
					next_no = "mv_3_end",
					)
	 EndNode(id = "mv_3_end")




	 YesNoCondition(
					id = "mv_4",
					condition = """
					Can two shadow armies merge where
					at least one is not *mobile*? If
					so, would the number of mobile
					armies increase or would it make
					an army have higher value then
					either of the two currently have?
					""",
					next_yes = "mv_4_yes",
					next_no = "mv_5",
					)
	 UseActiveDie(
				  id = "mv_4_yes",
				  next = "mv_4_action",
				  )
	 PerformAction(
				   id = "mv_4_action",
				   next = "mv_4_movement_remains",
				   action = """
				   Merge two armies.

				   Priority:
				   1. Merge decrease distance to
				   target
				   2. *Value* of resulting army
				   3. Moves the army furthest from
				   its *target*
				   4. Least number of units left
				   behind after move
				   5. Destination contains stronghold
				   """
				   )
	 YesNoCondition(
					id = "mv_4_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_4",
					next_no = "mv_4_end",
					)
	 EndNode(id = "mv_4_end")




	 StartNode(
			   id = "movement_attack_basic",
			   text = "Movement and Attack:\n Basic",
			   next = "mv_5",
			   )
	 YesNoCondition(
					id = "mv_5",
					condition = """
					Can a *mobile* army move towards,
					or attack, the closest *target*?
					""",
					next_yes = "mv_5_yes",
					next_no = "mv_6",
					)
	 UseActiveDie(
				  id = "mv_5_yes",
				  next = "mv_5_action",
				  )
	 PerformAction(
				   id = "mv_5_action",
				   next = "mv_5_movement_remains",
				   action = """
				   Move army towards, or use army to
				   attack, the closest *target*.

				   Priority:
				   1. Shadow army is adjacent to
				   *target*
				   2. Army whose *target* is in a
				   nation at war
				   3. Move/attack doesn't make a
				   passive nation active
				   4. Move/attack doesn't change
				   a nation to "at war"
				   5. By order of *target* priority
				   6. Shadow army with hightest
				   *value*
				   7. Move/attack does not block
				   another *mobile* army's shortest
				   route to their closest *target*
				   8. Destination region contains the
				   fellowship
				   """
				   )
	 YesNoCondition(
					id = "mv_5_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_5",
					next_no = "mv_5_end",
					)
	 EndNode(id = "mv_5_end")

	 YesNoCondition(
					id = "mv_6",
					condition = """
					Does SP have an army on the board?
					""",
					next_yes = "mv_6_yes",
					next_no = "mv_return",
					)
	 ReturnFromGraph(
					 id = "mv_return"
					 )
	 UseActiveDie(
				  id = "mv_6_yes",
				  next = "mv_6_action",
				  )
	 PerformAction(
				   id = "mv_6_action",
				   next = "mv_6_movement_remains",
				   action = """
				   Move an army.

				   Priority:
				   1. Move/attack doesn't change
				   a nation to "at war"
				   2. Highest army *value* of the
				   resulting army
				   3. Closest *target* of army have
				   a passive shadow army adjacent
				   4. Movement ends adjacent to
				   another shadow army
				   5. Decreases distance to closest
				   *target*
				   6. Shadow army with hightest
				   *value*
				   """
				   )
	 YesNoCondition(
					id = "mv_6_movement_remains",
					condition = """
					Was an army die used and
					does it have one move
					remaining?
					""",
					next_yes = "mv_6",
					next_no = "mv_6_end",
					)
	 EndNode(id = "mv_6_end")


	 ]
end
