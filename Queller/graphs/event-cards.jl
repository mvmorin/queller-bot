@graphs begin
	 ################################################################################
	 @node event_cards_preferred = Start() -> ep_1_strat

	 @node ep_1_strat = CheckStrategy("military") -> [n_true = ep_1_mili, n_false = ep_1_corr]
	 @node ep_1_mili = BinaryCondition("""
					 A card with army or muster type is *playable*.
					 """) -> [n_true = ep_2_yes, n_false = ep_return]
	 @node ep_1_corr = BinaryCondition("""
					 A card with character type is *playable*.
					 """) -> [n_true = ep_2_yes, n_false = ep_return]

	 @node ep_return = ReturnFromGraph() -> []
	 @node ep_2_yes = UseActiveDie() -> ep_2_strat
	 @node ep_2_strat = CheckStrategy("military") -> [n_true = ep_2_mili, n_false = ep_2_corr]
	 @node ep_2_mili = PerformAction("""
				   Play a *playable* card with muster or army type.

				   Priority:
				   1. Ascending Order of Initiative
				   2. Random
				   """) -> ep_2_end
	 @node ep_2_corr = PerformAction("""
				   Play a *playable* card with character type.

				   Priority:
				   1. Ascending Order of Initiative
				   2. Random
				   """) -> ep_2_end
	 @node ep_2_end = End() -> []


	 ################################################################################
	 @node event_cards_general = Start() -> eg_1
	 @node eg_1 = BinaryCondition("""
					 Holding less than 4 cards.
					 """) -> [n_true = eg_1_yes, n_false = eg_2]
	 @node eg_1_yes = UseActiveDie() -> eg_1_strat
	 @node eg_1_strat = CheckStrategy("military") -> [n_true = eg_1_mili, n_false = eg_1_corr]
	 @node eg_1_mili = PerformAction("""
				   Draw a strategy card.
				   """) -> eg_1_end
	 @node eg_1_corr = PerformAction("""
				   Draw a character card.
				   """) -> eg_1_end
	 @node eg_1_end = End() -> []


	 @node eg_2 = BinaryCondition("""
					 A card is *playable*.
					 """) -> [n_true = eg_2_yes, n_false = eg_3]
	 @node eg_2_yes = UseActiveDie() -> eg_2_action
	 @node eg_2_action = PerformAction("""
				   Play a *playable* card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """) -> eg_2_end
	 @node eg_2_end = End() -> []


	 @node eg_3 = UseActiveDie() -> eg_3_strat
	 @node eg_3_strat = CheckStrategy("military") -> [n_true = eg_3_mili, n_false = eg_3_corr]
	 @node eg_3_mili = PerformAction("""
				   Draw a strategy card.
				   """) -> eg_3_discard
	 @node eg_3_corr = PerformAction("""
				   Draw a character card.
				   """) -> eg_3_discard
	 @node eg_3_discard = BinaryCondition("""
					 Holding more than 6 cards.
					 """) -> [n_true = eg_3_discard_strat, n_false = eg_3_end]
	 @node eg_3_end = End() -> []

	 @node eg_3_discard_strat = CheckStrategy("military") -> [n_true = eg_3_discard_mili, n_false = eg_3_discard_corr]
	 @node eg_3_discard_mili = PerformAction("""
				   Discard down to 6 cards.

				   Priority:
				   1. Not a card with army or muster type
				   2. Doesn't use the term "Fellowship revealed"
				   3. Doesn't place a tile
				   4. Ascending order of initiative
				   5. Random
				   """) -> eg_3_discard_end
	 @node eg_3_discard_corr = PerformAction("""
				   Discard down to 6 cards.

				   Priority:
				   1. Not card with character type
				   2. Doesn't use the term "Fellowship revealed"
				   3. Doesn't place a tile
				   4. Ascending order of initiative
				   5. Random
				   """) -> eg_3_discard_end
	 @node eg_3_discard_end = End() -> []


	 ################################################################################
	 @node event_cards_corruption = Start() -> ec_1
	 @node ec_1 = BinaryCondition("""
					 A "Fellowship revealed" card is *playable*.
					 """) -> [n_true = ec_1_yes, n_false = ec_2]
	 @node ec_1_yes = UseActiveDie() -> ec_1_action
	 @node ec_1_action = PerformAction("""
				   Play a *playable* "Fellowship revealed" card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """) -> ec_1_end
	 @node ec_1_end = End() -> []

	 @node ec_2 = BinaryCondition("""
					 A card that adds corruption or adds a hunt tile is *playable*.
					 """) -> [n_true = ec_2_yes, n_false = ec_3]
	 @node ec_2_yes = UseActiveDie() -> ec_2_action
	 @node ec_2_action = PerformAction("""
				   Play a *playable* card which adds corruption or adds a hunt tile.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """) -> ec_2_end
	 @node ec_2_end = End() -> []

	 @node ec_3 = BinaryCondition("""
					 Holding less than 4 cards.
					 """) -> [n_true = ec_3_yes, n_false = ec_return]
	 @node ec_3_yes = UseActiveDie() -> ec_3_action
	 @node ec_3_action = PerformAction("""
				   Draw a character card.
				   """) -> ec_3_end
	 @node ec_3_end = End() -> []

	 @node ec_return = ReturnFromGraph() -> []


	 ################################################################################
	 @node event_cards_resolve_effect = Start() -> er_select_card_effect_choice
	 @node er_select_card_effect_choice = MultipleChoice("""
					Select card effect to resolve.

					1. Region selection for muster
					2. Army selection for movement or attack
					3. Move minion or Nazgûl
					4. Hunt allocation
					5. No effect, return to Phase 5 menu
					""") -> [er_muster, er_army, er_char_move, er_hunt, er_resolve_end]
	 @node er_muster = JumpToGraph("muster_card") -> er_resolve_end
	 @node er_army = JumpToGraph("movement_attack_card") -> er_resolve_end
	 @node er_char_move = MultipleChoice("""
					Select what to move.

					1. The Which King
					2. The Mouth of Sauron
					3. The Nazgûl
					4. Nothing
					""") -> [er_move_wk, er_move_mos, er_move_naz, er_select_card_effect_choice]
	 @node er_move_wk = JumpToGraph("character_wk_prio") -> er_resolve_end
	 @node er_move_mos = JumpToGraph("character_mos_prio") -> er_resolve_end
	 @node er_move_naz = JumpToGraph("character_nazgul_prio") -> er_resolve_end

	 @node er_hunt = CheckStrategy("military") -> [n_true = er_hunt_mili, n_false = er_hunt_corr]
	 @node er_hunt_mili = PerformAction("""
										Select a character or event die at random, roll a d6. On a 4+, add it to the hunt pool. Do this for each die it is possible to add to the hunt pool.
										""") -> er_resolve_end
	 @node er_hunt_corr = PerformAction("""
										Select a army, muster, muster/army, or event die at random, roll a d6. On a 4+, add it to the hunt pool. Do this for each die it is possible to add to the hunt pool.
										""") -> er_resolve_end
	 @node er_resolve_end = End() -> []
end
