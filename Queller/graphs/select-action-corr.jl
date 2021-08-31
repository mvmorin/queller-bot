@graphs begin
	################################################################################
	@node select_action_corr = Start() -> threat_check
	@node threat_check = JumpToGraph("threat_exposed") -> a1


	########################################
	@node a1 = Dummy() -> a1_1
	@node a1_1 = SetActiveDie('C', may_use_ring = true) -> [next = a1_2, no_die = a2]
	@node a1_2 = SetActiveDie('P', may_use_ring = true) -> [next = a1_cond, no_die = a2]
	@node a1_cond = BinaryCondition("""
									The Fellowship is on the Mordor track or is revealed.
									And, a character card is held.
									""") -> [n_true = a1_jump, n_false = a2]
	@node a1_jump = JumpToGraph("event_cards_corruption") -> a2

	#######################################
	@node a2 = Dummy() -> a2_1
	@node a2_1 = SetActiveDie('C') -> [next = a2_cond, no_die = a3]
	@node a2_cond = BinaryCondition("""
									The Fellowship is in a region with no Nazgûl and which Nazgûl can move to.
									""") -> [n_true = a2_jump, n_false = a3]
	@node a2_jump = JumpToGraph("character_move") -> a3

	#######################################
	@node a3 = Dummy() -> a3_1
	@node a3_1 = SetActiveDie('C', may_use_ring = true) -> [next = a3_cond, no_die = a4]
	@node a3_cond = BinaryCondition("""
									The Which King is in play and not in a *mobile* army but is able to create or join one.
									""") -> [n_true = a3_jump, n_false = a4]
	@node a3_jump = JumpToGraph("character_which_king") -> a4


	########################################
	@node a4 = Dummy() -> a4_1
	@node a4_1 = SetActiveDie('M', may_use_ring = true) -> [next = a4_jump, no_die = a5]
	@node a4_jump = JumpToGraph("muster_minion") -> a5


	########################################
	@node a5 = Dummy() -> a5_1
	@node a5_1 = SetActiveDie('M') -> [next = a5_jump, no_die = a6]
	@node a5_jump = JumpToGraph("muster_politics") -> a6


	########################################
	@node a6 = Dummy() -> a6_1_ring
	@node a6_1_ring = SetActiveDie('C', may_use_ring = true) -> [next = a6_cond_ring, no_die = a6_2_ring]
	@node a6_2_ring = SetActiveDie('A', may_use_ring = true) -> [next = a6_cond_ring, no_die = a7]
	@node a6_cond_ring = BinaryCondition("""
										 A *mobile* army is adjacent to its *target*.
										 And, the *target* gives enough points to win or the Fellowship is on the Mordor track.
										 """) -> [n_true = a6_jump_1_die_ring, n_false = a6_1_no_ring]
	@node a6_jump_1_die_ring = SetActiveDie('C', may_use_ring = true) -> [next = a6_jump_1_ring, no_die = a6_jump_2_die_ring]
	@node a6_jump_1_ring = JumpToGraph("character_army") -> a6_jump_2_die_ring
	@node a6_jump_2_die_ring = SetActiveDie('A', may_use_ring = true) -> [next = a6_jump_2_ring, no_die = a7]
	@node a6_jump_2_ring = JumpToGraph("movement_attack_basic") -> a7


	@node a6_1_no_ring = SetActiveDie('C') -> [next = a6_cond_no_ring, no_die = a6_2_no_ring]
	@node a6_2_no_ring = SetActiveDie('A') -> [next = a6_cond_no_ring, no_die = a7]
	@node a6_cond_no_ring = BinaryCondition("""
											A *mobile* army is adjacent to its *target*.
											And, the *target* is in a nation at war and not under siege.
											""") -> [n_true = a6_jump_1_die_no_ring, n_false = a7]
	@node a6_jump_1_die_no_ring = SetActiveDie('C') -> [next = a6_jump_1_no_ring, no_die = a6_jump_2_die_no_ring]
	@node a6_jump_1_no_ring = JumpToGraph("character_army") -> a6_jump_2_die_no_ring
	@node a6_jump_2_die_no_ring = SetActiveDie('A') -> [next = a6_jump_2_no_ring, no_die = a7]
	@node a6_jump_2_no_ring = JumpToGraph("movement_attack_basic") -> a7


	########################################
	@node a7 = Dummy() -> a7_1
	@node a7_1 = BinaryCondition("The Shadow player is allowed to pass.") -> [n_true = a7_action, n_false = a8]
	@node a7_action = PerformAction("Pass") -> a7_end
	@node a7_end = End() -> []


	########################################
	@node a8 = Dummy() -> a8_1
	@node a8_1 = SetActiveDie('C') -> [next = a8_jump_1, no_die = a8_2]
	@node a8_jump_1 = JumpToGraph("event_cards_preferred") -> a8_2
	@node a8_2 = SetActiveDie('P') -> [next = a8_jump_2, no_die = a9]
	@node a8_jump_2 = JumpToGraph("event_cards_preferred") -> a9


	########################################
	@node a9 = Dummy() -> a9_1
	@node a9_1 = SetActiveDie('C') -> [next = a9_cond, no_die = a9_2]
	@node a9_2 = SetActiveDie('A') -> [next = a9_cond, no_die = a10]
	@node a9_cond = BinaryCondition("""
									A *mobile* army is adjacent to its *target* that is not under siege.
									""") -> [n_true = a9_jump_1_die, n_false = a10]
	@node a9_jump_1_die = SetActiveDie('C') -> [next = a9_jump_1, no_die = a9_jump_2_die]
	@node a9_jump_1 = JumpToGraph("character_army") -> a9_jump_2_die
	@node a9_jump_2_die = SetActiveDie('A') -> [next = a9_jump_2, no_die = a10]
	@node a9_jump_2 = JumpToGraph("movement_attack_basic") -> a10


	#######################################
	@node a10 = Dummy() -> a10_start
	@node a10_start = SetActiveDie('P') -> [next = a10_1, no_die = a11]
	@node a10_1 = JumpToGraph("event_cards_preferred") -> a10_2
	@node a10_2 = JumpToGraph("event_cards_general") -> a11



	########################################
	@node a11 = Dummy() -> a11_1
	@node a11_1 = SetActiveDie('A') -> [next = a11_action, no_die = a12]
	@node a11_action = JumpToGraph("movement_attack_corr") -> a12


	########################################
	@node a12 = Dummy() -> a12_start
	@node a12_start = SetActiveDie('C') -> [next = a12_1, no_die = a13]
	@node a12_1 = JumpToGraph("character_army") -> a13

	########################################
	@node a13 = Dummy() -> a13_start
	@node a13_start = SetActiveDie('M') -> [next = a13_1, no_die = a14]
	@node a13_1 = JumpToGraph("muster_minion") -> a13_2
	@node a13_2 = JumpToGraph("muster_politics") -> a13_3
	@node a13_3 = JumpToGraph("muster_muster") -> a14

	########################################
	@node a14 = Dummy() -> a14_1
	@node a14_1 = PerformAction("""
								Queller failed to find an action. Discard a random non-*preferred* die (this can be done in the main menu).
								""") -> a_end
	@node a_end = End() -> []

end
