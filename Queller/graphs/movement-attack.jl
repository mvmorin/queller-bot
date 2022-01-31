@graphs begin
	generic_move = """
	Move according to the latest statement. Select army at random if several can perform such a move.
	"""

	settlement_cond = """
	An army can move into an emtpy settlement of a nation at war.
	"""
	settlement_cond_2 = """
	An army can move into an empty settlement of a nation at war, without increasing the distance to its *target* (the *target* may change).
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
	Or, the merged army would have higher *value* then either of the two currently have.
	"""

	merge_move = """
	Merge two armies.

	Priority:
	1. Merge decrease greatest distance to *target* (*target* may change)
	2. Highest *value* of resulting army
	3. Moves the army furthest from its *target*
	4. Least number of units left behind after move
	5. Region where armies merge contains a stronghold
	6. Random
	"""

	move_target_cond = """
	A *mobile* army can move towards, or attack, its *target*.
	"""

	move_target = """
	Select a *mobile* army and move towards or attack *target*.

	Priority:
	1. Army is adjacent to its *target*
	2. Army's *target* is in a nation at war
	3. Move/attack doesn't activate a nation
	4. Move/attack doesn't change a nation to "at war"
	5. Army whose *target* is highest in the priority list in the definition of *target*
	6. Army with hightest *value*
	7. Move/attack does not block another *mobile* army's shortest route to their *target*
	8. Destination region contains the Fellowship
	9. Random
	"""

	basic_move_cond = """
	A Shadow army is on the board.
	"""

	basic_move = """
	Move an army.

	Priority:
	1. Move doesn't change a nation to "at war"
	2. Merge two armies to create the highest army *value* possible
	3. Army's *target* is adjacent to a passive Shadow army
	4. Movement ends adjacent to another Shadow army
	5. Decreases distance to *target* (*target* may change)
	6. Army with hightest *value*
	7. Random
	"""

	one_move_left_on_die = """
	The Army Die have one move remaining.
	"""

	################################################################################
	@node movement_attack_besiege = Start() -> mv_1

	@node mv_1 = BinaryCondition("""
								 A *mobile* army is adjacent to *target* not under siege.
								 """) -> [n_true = mv_1_yes, n_false = mv_1_return]
	@node mv_1_return = ReturnFromGraph() -> []
	@node mv_1_yes = UseActiveDie() -> mv_1_action
	@node mv_1_action = PerformAction("""
									  Attack with army adjacent to *target* not under siege.

									  Priority:
									  1. Army whose *target* is in a nation at war
									  2. Army whose attack would not put a nation at war.
									  3. Army whose *target* is in an active nation
									  4. Highest *value* army
									  5. Random
									  """) -> mv_1_end
	@node mv_1_end = End() -> []




	################################################################################
	@node movement_attack_corr = Start() -> mv_2
	@node mv_2 = BinaryCondition("""
								 There are Eyes in the hunt pool.
								 And, no army is in the Fellowship's region
								 And, the Fellowship do not reach mordor with the current progress.
								 And, an army can move into the Fellowship's region without increasing the distance to its *target* (the *target* may change).
								 """) -> [n_true = mv_2_yes, n_false = mv_3]
	@node mv_2_yes = UseActiveDie() -> mv_2_action
	@node mv_2_action = PerformAction(generic_move) -> mv_2_army_die_to_move
	@node mv_2_army_die_to_move = CheckActiveDie('A') -> [n_true=mv_2_movement_remains, n_false=mv_2_end]
	@node mv_2_movement_remains = BinaryCondition(one_move_left_on_die) -> [n_true = mv_2, n_false = mv_2_end]
	@node mv_2_end = End() -> []


	########################################
	@node mv_3 = BinaryCondition(settlement_cond) -> [n_true = mv_3_1, n_false = mv_4]
	@node mv_3_1 = BinaryCondition(settlement_cond_2) -> [n_true = mv_3_yes, n_false = mv_3_no]
	@node mv_3_yes = UseActiveDie() -> mv_3_yes_action
	@node mv_3_yes_action = PerformAction(generic_move) -> mv_3_movement_remains
	@node mv_3_no = UseActiveDie() -> mv_3_no_action
	@node mv_3_no_action = PerformAction(settlement_move_unit) -> mv_3_army_die_to_move
	@node mv_3_army_die_to_move = CheckActiveDie('A') -> [n_true=mv_3_movement_remains, n_false=mv_3_end]
	@node mv_3_movement_remains = BinaryCondition(one_move_left_on_die) -> [n_true = mv_3, n_false = mv_3_end]
	@node mv_3_end = End() -> []


	########################################
	@node mv_4 = BinaryCondition(merge_cond) -> [n_true = mv_4_yes, n_false = mv_5]
	@node mv_4_yes = UseActiveDie() -> mv_4_action
	@node mv_4_action = PerformAction(merge_move) -> mv_4_army_die_to_move
	@node mv_4_army_die_to_move = CheckActiveDie('A') -> [n_true=mv_4_movement_remains, n_false=mv_4_end]
	@node mv_4_movement_remains = BinaryCondition(one_move_left_on_die) -> [n_true = mv_4, n_false = mv_4_end]
	@node mv_4_end = End() -> []



	################################################################################
	@node movement_attack_basic = Start() -> mv_5
	@node mv_5 = BinaryCondition(move_target_cond) -> [n_true = mv_5_yes, n_false = mv_6]
	@node mv_5_yes = UseActiveDie() -> mv_5_action
	@node mv_5_action = PerformAction(move_target) -> mv_5_army_die_to_move
	@node mv_5_army_die_to_move = CheckActiveDie('A') -> [n_true=mv_5_movement_remains, n_false=mv_5_end]
	@node mv_5_movement_remains = BinaryCondition(one_move_left_on_die) -> [n_true = mv_5, n_false = mv_5_end]
	@node mv_5_end = End() -> []


	########################################
	@node mv_6 = BinaryCondition(basic_move_cond) -> [n_true = mv_6_yes, n_false = mv_6_return_okay]

	@node mv_6_return_okay = BinaryCondition("""
											 An Army Die has been used with one move remaining.
											 """) -> [n_true = mv_6_return_end, n_false = mv_6_return]
	@node mv_6_return_end = End() -> []
	@node mv_6_return = ReturnFromGraph() -> []

	@node mv_6_yes = UseActiveDie() -> mv_6_action
	@node mv_6_action = PerformAction(basic_move) -> mv_6_army_die_to_move
	@node mv_6_army_die_to_move = CheckActiveDie('A') -> [n_true=mv_6_movement_remains, n_false=mv_6_end]
	@node mv_6_movement_remains = BinaryCondition(one_move_left_on_die) -> [n_true = mv_6, n_false = mv_6_end]
	@node mv_6_end = End() -> []


	################################################################################
	@node movement_attack_card = Start() -> mv_c_1

	@node mv_c_1 = BinaryCondition(settlement_cond) -> [n_true = mv_c_1_1, n_false = mv_c_2]
	@node mv_c_1_1 = BinaryCondition(settlement_cond_2) -> [n_true = mv_c_1_army, n_false = mv_c_1_unit]
	@node mv_c_1_army = PerformAction(generic_move) -> mv_c_1_army_end
	@node mv_c_1_army_end = End() -> []

	@node mv_c_1_unit = PerformAction(settlement_move_unit) -> mv_c_1_unit_end
	@node mv_c_1_unit_end = End() -> []

	@node mv_c_2 = BinaryCondition(merge_cond) -> [n_true = mv_c_2_move, n_false = mv_c_3]
	@node mv_c_2_move = PerformAction(merge_move) -> mv_c_2_end
	@node mv_c_2_end = End() -> []

	@node mv_c_3 = BinaryCondition(move_target_cond) -> [n_true = mv_c_3_move, n_false = mv_c_4_move]
	@node mv_c_3_move = PerformAction(move_target) -> mv_c_3_end
	@node mv_c_3_end = End() -> []

	@node mv_c_4_move = PerformAction(basic_move) -> mv_c_4_end
	@node mv_c_4_end = End() -> []

end
