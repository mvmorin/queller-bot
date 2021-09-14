@graphs begin
	################################################################################
	@node select_action_mili = Start() -> threat_check
	@node threat_check = JumpToGraph("threat_exposed") -> a1


	########################################
	@node a1 = Dummy() -> a1_1
	@node a1_1 = SetActiveDie('C', may_use_ring = true) -> [next = a1_cond, no_die = a2]
	@node a1_cond = BinaryCondition("""
									The Which King is in play and not in a *mobile* army but is able to create or join one.
									""") -> [n_true = a1_jump, n_false = a2]
	@node a1_jump = JumpToGraph("character_which_king") -> a2


	########################################
	@node a2 = Dummy() -> a2_1
	@node a2_1 = SetActiveDie('M', may_use_ring = true) -> [next = a2_jump, no_die = a3]
	@node a2_jump = JumpToGraph("muster_minion") -> a3


	########################################
	@node a3 = Dummy() -> a3_1
	@node a3_1 = SetActiveDie('M') -> [next = a3_jump, no_die = a4]
	@node a3_jump = JumpToGraph("muster_politics") -> a4


	########################################
	@node a4 = Dummy() -> a4_1
	@node a4_1 = SetActiveDie('C', may_use_ring = true) -> [next = a4_2, no_die = a5]
	@node a4_2 = SetActiveDie('P', may_use_ring = true) -> [next = a4_cond, no_die = a5]
	@node a4_cond = BinaryCondition("""
									The Fellowship is on the Mordor track or is revealed.
									And, a "Fellowship revealed" character card is held.
									""") -> [n_true = a4_die, n_false = a5]
	@node a4_die = UseActiveDie() -> a4_action
	@node a4_action = PerformAction("""
									Play a "Fellowship revealed" character card.

									Priority:
									1. Ascending order of initiative
									2. Random
									""") -> a4_end
	@node a4_end = End() -> []


	########################################
	@node a5 = Dummy() -> a5_1
	@node a5_1 = SetActiveDie('C', may_use_ring = true) -> [next = a5_2, no_die = a6]
	@node a5_2 = SetActiveDie('A', may_use_ring = true) -> [next = a5_cond, no_die = a6]
	@node a5_cond = BinaryCondition("""
									A *mobile* army is adjacent to its *target* or has another *mobile* army blocking the shortest route to *target*.

									And, any of the following conditions hold:
									- The *mobile* army's *target* gives enough points to win.
									- The *mobile* army's *target* is in a nation at war and not under siege.
									- The Fellowship is on the Mordor track.
									""") -> [n_true = a5_action, n_false = a6]
	@node a5_action = JumpToGraph("movement_attack_basic") -> a6


	########################################
	@node a6 = Dummy() -> a6_1
	@node a6_1 = SetActiveDie('M') -> [next = a6_cond, no_die = a7]
	@node a6_cond = BinaryCondition("""
									A strategy card that musters is *playable*.
									""") -> [n_true = a6_die, n_false = a6_2]
	@node a6_2 = SetActiveDie('A') -> [next = a6_cond_2, no_die = a7]
	@node a6_cond_2 = BinaryCondition("""
									  A strategy card that musters is *playable*.
									  """) -> [n_true = a6_die, n_false = a7]
	@node a6_die = UseActiveDie() -> a6_action
	@node a6_action = PerformAction("""
									Play a strategy card that musters.

									Priority:
									3. Ascending order of initiative
									4. Random
									""") -> a6_end
	@node a6_end = End() -> []


	########################################
	@node a7 = Dummy() -> a7_1
	@node a7_1 = BinaryCondition("The Shadow player is allowed to pass.") -> [n_true = a7_action, n_false = a8]
	@node a7_action = PerformAction("Pass") -> a7_end
	@node a7_end = End() -> []


	########################################
	@node a8 = Dummy() -> a8_1
	@node a8_1 = SetActiveDie('P') -> [next = a8_jump_1, no_die = a9]
	@node a8_jump_1 = JumpToGraph("event_cards_preferred") -> a8_jump_2
	@node a8_jump_2 = JumpToGraph("event_cards_general") -> a9


	########################################
	@node a9 = Dummy() -> a9_1
	@node a9_1 = SetActiveDie('C') -> [next = a9_2, no_die = a10]
	@node a9_2 = SetActiveDie('A') -> [next = a9_cond, no_die = a10]
	@node a9_cond = BinaryCondition("""
									A *mobile* army is adjacent to its *target*.
									""") -> [n_true = a9_action, n_false = a10]
	@node a9_action = JumpToGraph("movement_attack_basic") -> a10


	########################################
	@node a10 = Dummy() -> a10_1
	@node a10_1 = SetActiveDie('A') -> [next = a10_action, no_die = a11]
	@node a10_action = JumpToGraph("movement_attack_corr") -> a11


	########################################
	@node a11 = Dummy() -> a11_1
	@node a11_1 = SetActiveDie('C') -> [next = a11_action, no_die = a12]
	@node a11_action = JumpToGraph("character_army") -> a12


	########################################
	@node a12 = Dummy() -> a12_start
	@node a12_start = SetActiveDie('M') -> [next = a12_1, no_die = a13]
	@node a12_1 = JumpToGraph("muster_minion") -> a12_2
	@node a12_2 = JumpToGraph("muster_politics") -> a12_3
	@node a12_3 = JumpToGraph("muster_muster") -> a13


	########################################
	@node a13 = Dummy() -> a13_1
	@node a13_1 = CheckStrategy("military") -> [n_true = a13_mili, n_false = a13_corr]
	@node a13_mili = PerformAction("""
								   Queller failed to find an action. Discard a random Character or Event die if possible, otherwise discard a random die (do not discard a die set aside for later use).
								   """) -> a13_dice
	@node a13_corr = PerformAction("""
								   Queller failed to find an action. Discard a random Army, Muster, Muster/Army or Event die if possible, otherwise discard a random die (do not discard a die set aside for later use).
								   """) -> a13_dice
	@node a13_dice = GetAvailableDice("""
									  After discarding the random die, input the remaining available dice here (not counting dice set aside for later use).
									  """) -> a_end
	@node a_end = End() -> []

end
