@graphs begin
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
	Army/armies can move towards an *exposed* region.
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

	@node threat_exposed = Start("Threat or Exposed") -> tx_t
	@node tx_t = BinaryCondition("A *threat* exist.") -> [n_true = tx_1, n_false = tx_5]

	########################################
	@node tx_1 = SetActiveDie('C') -> [next = tx_1_char_cond, no_die = tx_1_army]

	@node tx_1_char_cond = BinaryCondition(attack_threat_cond) -> [n_true = tx_1_use_die, n_false = tx_1_army]
	@node tx_1_army = SetActiveDie('A', may_use_ring = true) -> [next = tx_1_army_cond, no_die = tx_2]

	@node tx_1_army_cond = BinaryCondition(attack_threat_cond) -> [n_true = tx_1_use_die, n_false = tx_2]
	@node tx_1_use_die = UseActiveDie() -> tx_1_action
	@node tx_1_action = PerformAction(attack_text) -> tx_1_end
	@node tx_1_end = End() -> []


	########################################
	@node tx_2 = SetActiveDie('C') -> [next = tx_2_char_cond, no_die = tx_2_army]

	@node tx_2_char_cond = BinaryCondition(move_adjacent_cond) -> [n_true = tx_move_use_die, n_false = tx_2_army]
	@node tx_2_army = SetActiveDie('A', may_use_ring = true) -> [next = tx_2_army_cond, no_die = tx_3]

	@node tx_2_army_cond = BinaryCondition(move_adjacent_cond) -> [n_true = tx_move_use_die, n_false = tx_3]


	########################################
	@node tx_3 = SetActiveDie('C') -> [next = tx_3_char_cond, no_die = tx_3_army]

	@node tx_3_char_cond = BinaryCondition(move_stronghold_cond) -> [n_true = tx_move_use_die, n_false = tx_3_army]
	@node tx_3_army = SetActiveDie('A', may_use_ring = true) -> [next = tx_3_army_cond, no_die = tx_4]

	@node tx_3_army_cond = BinaryCondition(move_stronghold_cond) -> [n_true = tx_move_use_die, n_false = tx_4]


	########################################
	@node tx_4 = SetActiveDie('C') -> [next = tx_4_char_cond, no_die = tx_4_army]

	@node tx_4_char_cond = BinaryCondition(move_toward_cond) -> [n_true = tx_move_use_die, n_false = tx_4_army]
	@node tx_4_army = SetActiveDie('A', may_use_ring = true) -> [next = tx_4_army_cond, no_die = tx_5]

	@node tx_4_army_cond = BinaryCondition(move_toward_cond) -> [n_true = tx_move_use_die, n_false = tx_5]


	########################################
	@node tx_5 = SetActiveDie('C') -> [next = tx_5_char_cond, no_die = tx_5_army]

	@node tx_5_char_cond = BinaryCondition(move_exposed_cond) -> [n_true = tx_move_use_die, n_false = tx_5_army]
	@node tx_5_army = SetActiveDie('A', may_use_ring = true) -> [next = tx_5_army_cond, no_die = tx_m]

	@node tx_5_army_cond = BinaryCondition(move_exposed_cond) -> [n_true = tx_move_use_die, n_false = tx_m]


	########################################
	@node tx_move_use_die = UseActiveDie() -> tx_move_action
	@node tx_move_action = PerformAction(move_text) -> tx_move_movement_remains
	@node tx_move_movement_remains = BinaryCondition(move_remain_cond) -> [n_true = tx_use_remaining_movement, n_false = tx_move_end]
	@node tx_use_remaining_movement = JumpToGraph("Movement and Attack:\nCorruption",
												  "movement_attack_corr") -> tx_m
	@node tx_move_end = End() -> []


	########################################
	@node tx_m = SetActiveDie('M', may_use_ring = true) -> [next = tx_m_cond, no_die = tx_c]

	@node tx_m_cond = BinaryCondition(muster_cond) -> [n_true = tx_m_die, n_false = tx_c]
	@node tx_m_die = UseActiveDie() -> tx_m_action
	@node tx_m_action = PerformAction(muster_text) -> tx_m_end
	@node tx_m_end = End() -> []


	########################################
	@node tx_c = SetActiveDie('C', may_use_ring = true) -> [next = tx_c_cond, no_die = tx_return]

	@node tx_c_cond = BinaryCondition(character_cond) -> [n_true = tx_c_1, n_false = tx_return]
	@node tx_c_1 = JumpToGraph("Characters:\nCharacter Movement",
							   "character_move") -> tx_return


	########################################
	@node tx_return = ReturnFromGraph() -> []
end
