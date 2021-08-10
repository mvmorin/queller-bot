let
	settlement_cond = """
	An army can move into an emtpy settlement of a nation at war.
	"""
	settlement_cond_2 = """
	An army can move into an empty settlement of a nation at war, without increasing the distance to its *target* (the *target* may change).
	"""
	settlement_move_army = """
	Move: Select army at random if several armies satisfy the latest considered move.
	"""
	settlement_move_unit = """
	Move 1 unit into an empty settlement of nation at war.

	Army priority: Random

	Unit priority:
	1. Regular
	2. Elite
	3. Random
	"""

	merge_cond = """
	Two armies, where at least one is not *mobile*, can merge.
	And, merging the armies would increase the number of *mobile* armies.
	Or, the merged army would have higher value then either of the two currently have.
	"""

	merge_move = """
	Merge two armies.

	Priority:
	1. Merge decrease distance to *target* (*target* may change)
	2. *Value* of resulting army
	3. Moves the army furthest from its *target*
	4. Least number of units left behind after move
	5. Destination contains stronghold
	6. Random
	"""

	move_target_cond = """
	A *mobile* army can move towards, or attack, its *target*.
	"""

	move_target = """
	Select a *mobile* army and move towards *target* or attack *target*.

	Priority:
	1. Shadow army is adjacent to *target*
	2. Army whose *target* is in a nation at war
	3. Move/attack doesn't activate a nation
	4. Move/attack doesn't change a nation to "at war"
	5. By order of *target* priority
	6. Shadow army with hightest *value*
	7. Move/attack does not block another *mobile* army's shortest route to their *target*
	8. Destination region contains the fellowship
	9. Random
	"""

	basic_move_cond = """
	A Shadow army is on the board.
	"""

	basic_move = """
	Move an army.

	Priority:
	1. Move/attack doesn't change a nation to "at war"
	2. Highest army *value* of the resulting army
	3. *Target* of army have a passive shadow army adjacent
	4. Movement ends adjacent to another shadow army
	5. Decreases distance to *target* (*target* may change)
	6. Shadow army with hightest *value*
	7. Random
	"""

	[
################################################################################
	 StartNode(
			   id = "movement_attack_besiege",
			   text = "Movement and Attack:\n Besiege",
			   next = "mv_1",
			   )

	 BinaryCondition(
					id = "mv_1",
					condition = """
					A *mobile* army is adjacent to *target* not under siege.
					""",
					next_true = "mv_1_yes",
					next_false = "mv_1_return",
					)
	 ReturnFromGraph(
					 id = "mv_1_return",
					 )
	 UseActiveDie(
				  id = "mv_1_yes",
				  next = "mv_1_action",
				  )
	 PerformAction(
				   id = "mv_1_action",
				   next = "mv_1_end",
				   action = """
				   Attack with army adjacent to *target* not under siege.

				   Priority:
				   1. Army whose *target* is in a nation at war
				   2. Army whose attack would not put a nation at war.
				   3. Army whose *target* is in an active nation
				   4. Highest value shadow army
				   5. Random
				   """
				   )
	 EndNode(id = "mv_1_end")




################################################################################
	 StartNode(
			   id = "movement_attack_corr",
			   text = "Movement and Attack:\n Corruption",
			   next = "mv_2",
			   )
	 BinaryCondition(
					id = "mv_2",
					condition = """
					There are dice in the hunt pool.
					And, no army is in the Fellowship's region.
					And, an army can move into that region without increasing the distance to its *target* (the *target* may change).
					""",
					next_true = "mv_2_yes",
					next_false = "mv_3",
					)
	 UseActiveDie(
				  id = "mv_2_yes",
				  next = "mv_2_action",
				  )
	 PerformAction(
				   id = "mv_2_action",
				   next = "mv_2_movement_remains",
				   action = """
				   Move: Select army at random if several armies satisfy the latest considered move.
				   """
				   )
	 BinaryCondition(
					id = "mv_2_movement_remains",
					condition = """
					An army die was used and it have one move remaining.
					""",
					next_true = "mv_2",
					next_false = "mv_2_end",
					)
	 EndNode(id = "mv_2_end")






	 BinaryCondition(
					id = "mv_3",
					condition = settlement_cond,
					next_true = "mv_3_1",
					next_false = "mv_4",
					)
	 BinaryCondition(
					id = "mv_3_1",
					condition = settlement_cond_2,
					next_true = "mv_3_yes",
					next_false = "mv_3_no",
					)
	 UseActiveDie(
				  id = "mv_3_yes",
				  next = "mv_3_yes_action",
				  )
	 PerformAction(
				   id = "mv_3_yes_action",
				   next = "mv_3_movement_remains",
				   action = settlement_move_army,
				   )
	 UseActiveDie(
				  id = "mv_3_no",
				  next = "mv_3_no_action",
				  )
	 PerformAction(
				   id = "mv_3_no_action",
				   next = "mv_3_movement_remains",
				   action = settlement_move_unit,
				   )
	 BinaryCondition(
					id = "mv_3_movement_remains",
					condition = """
					An army die was used and it have one move remaining.
					""",
					next_true = "mv_3",
					next_false = "mv_3_end",
					)
	 EndNode(id = "mv_3_end")




	 BinaryCondition(
					id = "mv_4",
					condition = merge_cond,
					next_true = "mv_4_yes",
					next_false = "mv_5",
					)
	 UseActiveDie(
				  id = "mv_4_yes",
				  next = "mv_4_action",
				  )
	 PerformAction(
				   id = "mv_4_action",
				   next = "mv_4_movement_remains",
				   action = merge_move,
				   )
	 BinaryCondition(
					id = "mv_4_movement_remains",
					condition = """
					An army die was used and it have one move remaining.
					""",
					next_true = "mv_4",
					next_false = "mv_4_end",
					)
	 EndNode(id = "mv_4_end")




	 StartNode(
			   id = "movement_attack_basic",
			   text = "Movement and Attack:\n Basic",
			   next = "mv_5",
			   )
	 BinaryCondition(
					id = "mv_5",
					condition = move_target_cond,
					next_true = "mv_5_yes",
					next_false = "mv_6",
					)
	 UseActiveDie(
				  id = "mv_5_yes",
				  next = "mv_5_action",
				  )
	 PerformAction(
				   id = "mv_5_action",
				   next = "mv_5_movement_remains",
				   action = move_target,
				   )
	 BinaryCondition(
					id = "mv_5_movement_remains",
					condition = """
					An army die was used and it have one move remaining.
					""",
					next_true = "mv_5",
					next_false = "mv_5_end",
					)
	 EndNode(id = "mv_5_end")


	 BinaryCondition(
					id = "mv_6",
					condition = basic_move_cond,
					next_true = "mv_6_yes",
					next_false = "mv_return",
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
				   action = basic_move,
				   )
	 BinaryCondition(
					id = "mv_6_movement_remains",
					condition = """
					An army die was used and it have one move remaining.
					""",
					next_true = "mv_6",
					next_false = "mv_6_end",
					)
	 EndNode(id = "mv_6_end")




################################################################################
	 StartNode(
			   id = "movement_attack_card",
			   text = "Movement and Attack:\n Card",
			   next = "mv_c_1",
			   )

	 BinaryCondition(
					id = "mv_c_1",
					condition = settlement_cond,
					next_true = "mv_c_1_1",
					next_false = "mv_c_2",
					)
	 BinaryCondition(
					id = "mv_c_1_1",
					condition = settlement_cond_2,
					next_true = "mv_c_1_army",
					next_false = "mv_c_1_unit",
					)
	 PerformAction(
				   id = "mv_c_1_army",
				   next = "mv_c_1_army_end",
				   action = settlement_move_army,
				   )
	 EndNode(id = "mv_c_1_army_end")
	 PerformAction(
				   id = "mv_c_1_unit",
				   next = "mv_c_1_unit_end",
				   action = settlement_move_unit,
				   )
	 EndNode(id = "mv_c_1_unit_end")


	 BinaryCondition(
					id = "mv_c_2",
					condition = merge_cond,
					next_true = "mv_c_2_move",
					next_false = "mv_c_3",
					)
	 PerformAction(
				   id = "mv_c_2_move",
				   next = "mv_c_2_end",
				   action = merge_move,
				   )
	 EndNode(id = "mv_c_2_end")



	 BinaryCondition(
					id = "mv_c_3",
					condition = move_target_cond,
					next_true = "mv_c_3_move",
					next_false = "mv_c_4_move",
					)
	 PerformAction(
				   id = "mv_c_3_move",
				   next = "mv_c_3_end",
				   action = move_target,
				   )
	 EndNode(id = "mv_c_3_end")


	 PerformAction(
				   id = "mv_c_4_move",
				   next = "mv_c_4_end",
				   action = basic_move,
				   )
	 EndNode(id = "mv_c_4_end")

	 ]
end
