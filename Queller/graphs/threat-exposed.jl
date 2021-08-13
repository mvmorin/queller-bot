let
	attack_threat_cond = """
	A *mobile* army can attack *threat*.
	"""

	move_adjacent_cond = """
	Army/armies can move so that a *mobile* army is created adjacent to *threat*.
	"""

	move_stronghold_cond = """
	Army/armies can move such that the value at stronghold under *threat* increases.
	"""

	move_toward_cond = """
	*Mobile* army/armies can move towards their *target*/*targets* and reduce their distance to the *threat*.
	"""

	move_exposed_cond = """
	Army/armies can move towards an *exposed* region?
	"""

	muster_cond = """
	Possible to muster at a stronghold under *threat*.
	"""

	character_cond = """
	A *threat* is besieging a Shadow stronghold whose army leadership is less than 5 and less than the number of army units.
	"""

	move_remain_cond = """
	An army die was used and it have one move remaining.
	"""


	attack_text = """
	Attack: Select army at random if several can perform the latest considered attack.
	"""

	move_text = """
	Move: Select army at random if several armies satisfy the latest considered move.
	"""

	muster_text = """
	*Focus* priority:
	1. Stronghold under threat
	2. Random

	Muster:
	*Primary*: Elite
	*Secondary*: Regular

	If unit is unavailable, rotate as:
	Elite -> Regular -> Nazgûl -> Elite
	"""


	################################################################################
	[
	 StartNode(
			   id = "threat_exposed",
			   text = "Threat or Exposed",
			   next = "tx_t",
			   )


	 BinaryCondition(
					 id = "tx_t",
					 condition = """
					 A *threat* exist.
					 """,
					 next_true = "tx_1",
					 next_false = "tx_5",
					 )


	 ########################################
	 SetActiveDie(
				  id = "tx_1",
				  next = "tx_1_char_cond",
				  next_no_die = "tx_1_army",
				  die = 'C',
				  )
	 BinaryCondition(
					 id = "tx_1_char_cond",
					 condition = attack_threat_cond,
					 next_true = "tx_1_use_die",
					 next_false = "tx_1_army",
					 )
	 SetActiveDie(
				  id = "tx_1_army",
				  next = "tx_1_army_cond",
				  next_no_die = "tx_2",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_1_army_cond",
					 condition = attack_threat_cond,
					 next_true = "tx_1_use_die",
					 next_false = "tx_2",
					 )
	 UseActiveDie(
				  id = "tx_1_use_die",
				  next = "tx_1_action",
				  )
	 PerformAction(
				   id = "tx_1_action",
				   next = "tx_1_end",
				   action = attack_text,
				   )
	 EndNode(id = "tx_1_end")


	 ########################################
	 SetActiveDie(
				  id = "tx_2",
				  next = "tx_2_char_cond",
				  next_no_die = "tx_2_army",
				  die = 'C',
				  )
	 BinaryCondition(
					 id = "tx_2_char_cond",
					 condition = move_adjacent_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_2_army",
					 )
	 SetActiveDie(
				  id = "tx_2_army",
				  next = "tx_2_army_cond",
				  next_no_die = "tx_3",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_2_army_cond",
					 condition = move_adjacent_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_3",
					 )


	 ########################################
	 SetActiveDie(
				  id = "tx_3",
				  next = "tx_3_char_cond",
				  next_no_die = "tx_3_army",
				  die = 'C',
				  )
	 BinaryCondition(
					 id = "tx_3_char_cond",
					 condition = move_stronghold_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_3_army",
					 )
	 SetActiveDie(
				  id = "tx_3_army",
				  next = "tx_3_army_cond",
				  next_no_die = "tx_4",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_3_army_cond",
					 condition = move_stronghold_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_4",
					 )


	 ########################################
	 SetActiveDie(
				  id = "tx_4",
				  next = "tx_4_char_cond",
				  next_no_die = "tx_4_army",
				  die = 'C',
				  )
	 BinaryCondition(
					 id = "tx_4_char_cond",
					 condition = move_toward_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_4_army",
					 )
	 SetActiveDie(
				  id = "tx_4_army",
				  next = "tx_4_army_cond",
				  next_no_die = "tx_5",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_4_army_cond",
					 condition = move_toward_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_5",
					 )


	 ########################################
	 SetActiveDie(
				  id = "tx_5",
				  next = "tx_5_char_cond",
				  next_no_die = "tx_5_army",
				  die = 'C',
				  )
	 BinaryCondition(
					 id = "tx_5_char_cond",
					 condition = move_exposed_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_5_army",
					 )
	 SetActiveDie(
				  id = "tx_5_army",
				  next = "tx_5_army_cond",
				  next_no_die = "tx_m",
				  die = 'A',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_5_army_cond",
					 condition = move_exposed_cond,
					 next_true = "tx_move_use_die",
					 next_false = "tx_m",
					 )


	 ########################################
	 UseActiveDie(
				  id = "tx_move_use_die",
				  next = "tx_move_action",
				  )
	 PerformAction(
				   id = "tx_move_action",
				   next = "tx_move_movement_remains",
				   action = move_text
				   )
	 BinaryCondition(
					 id = "tx_move_movement_remains",
					 condition = move_remain_cond,
					 next_true = "tx_use_remaining_movement",
					 next_false = "tx_move_end",
					 )
	 JumpToGraph(
				 id = "tx_use_remaining_movement",
				 text = "Movement and Attack:\nCorruption",
				 jump_graph = "movement_attack_corruption",
				 next = "tx_m",
				 )
	 EndNode(id = "tx_move_end")


	 ########################################
	 SetActiveDie(
				  id = "tx_m",
				  next = "tx_m_cond",
				  next_no_die = "tx_c",
				  die = 'M',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_m_cond",
					 condition = muster_cond,
					 next_true = "tx_m_die",
					 next_false = "tx_c",
					 )
	 UseActiveDie(
				  id = "tx_m_die",
				  next = "tx_m_action",
				  )
	 PerformAction(
				   id = "tx_m_action",
				   next = "tx_m_end",
				   action = muster_text,
				   )
	 EndNode(id = "tx_m_end")


	 ########################################
	 SetActiveDie(
				  id = "tx_c",
				  next = "tx_c_cond",
				  next_no_die = "tx_return",
				  die = 'C',
				  may_use_ring = true,
				  )
	 BinaryCondition(
					 id = "tx_c_cond",
					 condition = character_cond,
					 next_true = "tx_c_1",
					 next_false = "tx_return",
					 )
	 JumpToGraph(
				 id = "tx_c_1",
				 text = "Characters:\nCharacter Movement",
				 jump_graph = "characters_move",
				 next = "tx_return",
				 )


	 ########################################
	 ReturnFromGraph(
					 id = "tx_return"
					 )

	 ]
end
