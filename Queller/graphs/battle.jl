@graphs begin
	def_card_prio = """
	After the Free People's player have selected combat card, select and play a card. If no card is matching the 4 first items in the priority list, do not play any card.

	Priority:
	1. Strategy card that cancels the Free People's card
	2. Doesn't use the term "Fellowship revealed"
	3. Doesn't add a hunt tile or corruption
	4. Character card
	5. Ascending order of initiative
	6. Random

	If the selected card requires units to be downgraded or sacrificed, do so as long as the army does not become non-*aggressive*.
	"""

	sortie_card_prio = """
	After the Free People's player have selected combat card, select and play a card. If no card is matching the 2 first items in the priority list, do not play any card.

	Priority:
	1. Charcter card that doesn't use the term "Fellowship revealed"
	2. Character card that doesn't add a hunt tile or corruption
	3. Ascending order of initiative
	4. Random

	If the selected card requires units to be downgraded or sacrificed, do so as long as the army does not become non-*aggressive*.
	"""

	wk_card_prio = """
	After the Free People's player have selected combat card, select and play a card.

	Priority:
	1. Strategy card
	2. Durin's Bane
	3. Character card
	4. Doesn't use the term "Fellowship revealed"
	5. Doesn't add a hunt tile or corruption
	6. Ascending order of initiative
	7. Random

	If the selected card requires units to be downgraded or sacrificed, do so as long as the army does not become non-*aggressive*.
	"""

	attack_card_prio = """
	After the Free People's player have selected combat card, select and play a card.

	Priority:
	1. Durin's Bane
	2. Strategy card
	3. Character card
	4. Doesn't use the term "Fellowship revealed"
	5. Doesn't add a hunt tile or corruption
	6. Ascending order of initiative
	7. Random

	If the selected card requires units to be downgraded or sacrificed, do so as long as the army does not become non-*aggressive*.
	"""


	################################################################################
	 @node battle = Start("Battle") -> rearguard
	 @node rearguard = PerformAction("All units from nations not at war form the rearguard.") -> army_attacking
	 @node army_attacking = BinaryCondition("The Shadow army is attacking.") -> [n_true = is_sortie, n_false = def_in_stronghold]

	 ########################################
	 @node def_in_stronghold = BinaryCondition("""
					 The Shadow army is defending in a region with a stronghold.
					 """) -> [n_true = should_retreat_to_stronghold, n_false = field_def_card_prio]
	 @node field_def_card_prio = PerformAction(def_card_prio) -> field_def_resolve
	 @node field_def_resolve = JumpToGraph("Battle: Resolve",
										   "battle_resolve") -> field_attacking_fp_continues
	 @node field_attacking_fp_continues = BinaryCondition("""
														  The Free People's player is continuing the attack.
														  """) -> [n_true = retreat_prio, n_false = field_def_end]
	 @node retreat_prio = PerformAction("""
				   Retreat from combat into region accroding to the following prioirty.

				   Priority:
				   1. Does not creat a threat
				   2. Reduce distance to *target* or *exposed* region
				   3. Increase the number of *mobile* armies
				   4. Increase the number of *aggressive* armies
				   5. Contains a settlement
				   6. Contains the highest *value* army
				   7. Adjacent to the highest *value* army
				   8. Random
				   """) -> field_def_end
	 @node field_def_end = End("End of Battle") -> []


	 ########################################
	 @node should_retreat_to_stronghold = BinaryCondition("""
					 The Shadow army is not under siege.
					 And, the *value* is less or equal to the attacking army's.
					 And, the number of units is less than 8.
					 """) -> [n_true = retreat_to_stronghold, n_false = def_card_prio]
	 @node def_card_prio = PerformAction(def_card_prio) -> def_resolve
	 @node def_resolve = JumpToGraph("Battle: Resolve",
									 "battle_resolve") -> attacking_fp_continues
	 @node attacking_fp_continues = BinaryCondition("""
													The Free People's player is continuing the attack.
													""") -> [n_true = should_retreat_to_stronghold, n_false = def_end]
	 @node def_end = End("End of Battle") -> []

	 @node retreat_to_stronghold = PerformAction("Retreat into stronghold.") -> retreat_stronghold_end
	 @node retreat_stronghold_end = End("End of Battle") -> []


	 ########################################
	 @node is_sortie = BinaryCondition("Battle is a sortie.") -> [n_true = sortie_card_prio, n_false = army_with_wk]
	 @node sortie_card_prio = PerformAction(sortie_card_prio) -> sortie_resolve
	 @node sortie_resolve = JumpToGraph("Battle: Resolve",
										"battle_resolve") -> sortie_round_end
	 @node sortie_round_end = JumpToGraph("Battle: Round End",
										  "battle_round_end") -> sortie_card_prio


	 ########################################
	 @node army_with_wk = BinaryCondition("Army include the Witch King.") -> [n_true = wk_card_prio, n_false = should_play_card]
	 @node wk_card_prio = PerformAction(wk_card_prio) -> wk_resolve
	 @node wk_resolve = JumpToGraph("Battle: Resolve",
									"battle_resolve") -> wk_round_end
	 @node wk_round_end = JumpToGraph("Battle: Round End",
									  "battle_round_end") -> should_play_card


	 ########################################
	 @node should_play_card = BinaryCondition("""
					 The Shadow is conducting a siege.
					 Or, the Shadow is holding more than 4 cards.
					 """) -> [n_true = attack_card_prio, n_false = attack_play_no_card]

	 @node attack_card_prio = PerformAction(attack_card_prio) -> attack_resolve
	 @node attack_play_no_card = PerformAction("Do not play a combat card.") -> attack_resolve
	 @node attack_resolve = JumpToGraph("Battle: Resolve",
										"battle_resolve") -> attack_round_end
	 @node attack_round_end = JumpToGraph("Battle: Round End",
										  "battle_round_end") -> should_play_card


	 ################################################################################
	 @node battle_resolve = Start("Battle: Resolve") -> roll
	 @node roll = PerformAction("Roll for combat and reroll misses.") -> casualties
	 @node casualties = PerformAction("""
				   Remove casualties.

				   Priority:
				   1. Maximizes effect of the card played
				   2. Retains highest army *value* with lowest number of units
				   3. Keeps one unit of each nation
				   4. Random
				   """) -> battle_resolve_return
	 @node battle_resolve_return = ReturnFromGraph() -> []




	 ################################################################################
	 @node battle_round_end = Start("Battle: Round End") -> is_fp_dead
	 @node is_fp_dead = BinaryCondition("There are Free People's units remaining.") -> [n_true = press_on, n_false = no_fp_left]
	 @node no_fp_left = BinaryCondition("""
					 Moving in to the conquered region would:
					 - win the game; or
					 - decrease distance to *target*; or
					 - remove a threat.
					 """) -> [n_true = move_into_conquered, n_false = end_without_moving]

	 @node move_into_conquered = PerformAction("Move the largest *value* possible into the conquered region.") -> move_into_conquered_end
	 @node move_into_conquered_end = End("End of Battle") -> []


	 @node end_without_moving = PerformAction("Do not move any units into the conquered region.") -> end_without_moving_end
	 @node end_without_moving_end = End("End of Battle") -> []


	 @node press_on = BinaryCondition("""
					 A field battle was fought.
					 """) -> [n_true = aggressive_if_continue, n_false = mili_strat]
	 @node mili_strat = CheckStrategy("military") -> [n_true = aggressive_if_continue, n_false = press_on_2]
	 @node press_on_2 = BinaryCondition("""
					 The Fellowship is on the Mordor track.
					 """) -> [n_true = another_round_if_possible, n_false = no_more_round]
	 @node aggressive_if_continue = BinaryCondition("""
					 The Shadow army is *aggressive* and, if a siege battle is fought, would remain *aggressive* after an Elite downgrade to continue the battle.
					 """) -> [n_true = another_round_if_possible, n_false = no_more_round_2]
	 @node another_round_if_possible = BinaryCondition("A siege battle is fought and the Shadow army have no Elites left") -> [n_true = no_more_round_2, n_false = one_more_round]
	 @node one_more_round = PerformAction("Continue the battle, downgrade an Elite if necessary.") -> one_more_round_return
	 @node one_more_round_return = ReturnFromGraph() -> []


	 @node no_more_round = PerformAction("End battle") -> no_more_round_end
	 @node no_more_round_end = End("End of Battle") -> []

	 @node no_more_round_2 = PerformAction("End battle") -> no_more_round_end_2
	 @node no_more_round_end_2 = End("End of Battle") -> []

end
