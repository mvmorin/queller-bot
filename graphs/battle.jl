let
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
	[
	 StartNode(
			   id = "battle",
			   next = "rearguard",
			   text = "Battle",
			   )
	 PerformAction(
				   id = "rearguard",
				   next = "army_attacking",
				   action = "All units from nations not at war form the rearguard."
				   )
	 BinaryCondition(
					 id = "army_attacking",
					 condition = "The Shadow army is attacking.",
					 next_true = "is_sortie",
					 next_false = "def_in_stronghold",
					 )

########################################
	 BinaryCondition(
					 id = "def_in_stronghold",
					 condition = """
					 The Shadow army is defending in a region with a stronghold.
					 """,
					 next_true = "should_retreat_to_stronghold",
					 next_false = "field_def_card_prio",
					 )
	 PerformAction(
				   id = "field_def_card_prio",
				   action = def_card_prio,
				   next = "field_def_resolve",
				   )
	 JumpToGraph(
				 id = "field_def_resolve",
				 text = "Battle: Resolve",
				 next = "field_attacking_fp_continues",
				 jump_graph = "battle_resolve",
				 )
	 BinaryCondition(
					 id = "field_attacking_fp_continues",
					 condition = " The Free People's player is continuing the attack.",
					 next_true = "retreat_prio",
					 next_false = "field_def_end",
					 )
	 PerformAction(
				   id = "retreat_prio",
				   action = """
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
				   """,
				   next = "field_def_end",
				   )
	 EndNode(
			 id = "field_def_end",
			 text = "End of Battle",
			 )


########################################
	 BinaryCondition(
					 id = "should_retreat_to_stronghold",
					 condition = """
					 The Shadow army is not under siege.
					 And, the *value* is less or equal to the attacking army's.
					 And, the number of units is less than 8.
					 """,
					 next_true = "retreat_to_stronghold",
					 next_false = "def_card_prio",
					 )
	 PerformAction(
				   id = "def_card_prio",
				   action = def_card_prio,
				   next = "def_resolve",
				   )
	 JumpToGraph(
				 id = "def_resolve",
				 text = "Battle: Resolve",
				 next = "attacking_fp_continues",
				 jump_graph = "battle_resolve",
				 )
	 BinaryCondition(
					 id = "attacking_fp_continues",
					 condition = " The Free People's player is continuing the attack.",
					 next_true = "should_retreat_to_stronghold",
					 next_false = "def_end",
					 )
	 EndNode(
			 id = "def_end",
			 text = "End of Battle",
			 )

	 PerformAction(
				   id = "retreat_to_stronghold",
				   action = "Retreat into stronghold.",
				   next = "retreat_stronghold_end",
				   )
	 EndNode(
			 id = "retreat_stronghold_end",
			 text = "End of Battle",
			 )






 ########################################
	 BinaryCondition(
					 id = "is_sortie",
					 condition = "Battle is a sortie.",
					 next_true = "sortie_card_prio",
					 next_false = "army_with_wk",
					 )
	 PerformAction(
				   id = "sortie_card_prio",
				   action = sortie_card_prio,
				   next = "sortie_resolve",
				   )
	 JumpToGraph(
				 id = "sortie_resolve",
				 text = "Battle: Resolve",
				 next = "sortie_round_end",
				 jump_graph = "battle_resolve",
				 )
	 JumpToGraph(
				 id = "sortie_round_end",
				 text = "Battle: Round End",
				 next = "sortie_card_prio",
				 jump_graph = "battle_round_end",
				 )



########################################
	BinaryCondition(
					id = "army_with_wk",
					condition = "Army include the Witch King.",
					next_true = "wk_card_prio",
					next_false = "should_play_card",
					)
	 PerformAction(
				   id = "wk_card_prio",
				   action = wk_card_prio,
				   next = "wk_resolve",
				   )
	 JumpToGraph(
				 id = "wk_resolve",
				 text = "Battle: Resolve",
				 next = "wk_round_end",
				 jump_graph = "battle_resolve",
				 )
	 JumpToGraph(
				 id = "wk_round_end",
				 text = "Battle: Round End",
				 next = "should_play_card",
				 jump_graph = "battle_round_end",
				 )



########################################
	BinaryCondition(
					id = "should_play_card",
					condition = """
					The Shadow is conducting a siege.
					Or, the Shadow is holding more than 4 cards.
					""",
					next_true = "attack_card_prio",
					next_false = "attack_play_no_card",
					)

	 PerformAction(
				   id = "attack_card_prio",
				   action = attack_card_prio,
				   next = "attack_resolve",
				   )
	 PerformAction(
				   id = "attack_play_no_card",
				   action = "Do not play a combat card.",
				   next = "attack_resolve",
				   )
	 JumpToGraph(
				 id = "attack_resolve",
				 text = "Battle: Resolve",
				 next = "attack_round_end",
				 jump_graph = "battle_resolve",
				 )
	 JumpToGraph(
				 id = "attack_round_end",
				 text = "Battle: Round End",
				 next = "should_play_card",
				 jump_graph = "battle_round_end",
				 )




################################################################################
	 StartNode(
			   id = "battle_resolve",
			   text = "Battle: Resolve",
			   next = "roll",
			   )
	 PerformAction(
				   id = "roll",
				   next = "casualties",
				   action = "Roll for combat and reroll misses.",
				   )
	 PerformAction(
				   id = "casualties",
				   next = "battle_resolve_return",
				   action = """
				   Remove casualties.

				   Priority:
				   1. Maximizes effect of the card played
				   2. Retains highest army *value* with lowest number of units
				   3. Keeps one unit of each nation
				   4. Random
				   """,
				   )
	 ReturnFromGraph(id = "battle_resolve_return")




################################################################################
	 StartNode(
			   id = "battle_round_end",
			   text = "Battle: Round End",
			   next = "is_fp_dead",
			   )
	 BinaryCondition(
					 id = "is_fp_dead",
					 condition = "There are Free People's units remaining.",
					 next_true = "press_on",
					 next_false = "no_fp_left",
					 )
	 BinaryCondition(
					 id = "no_fp_left",
					 condition = """
					 Moving in to the conquered region would:
					 - win the game; or
					 - decrease distance to *target*; or
					 - remove a threat.
					 """,
					 next_true = "move_into_conquered",
					 next_false = "end_without_moving",
					 )

	 PerformAction(
					  id = "move_into_conquered",
					  action = "Move the largest *value* possible into the conquered region.",
					  next = "move_into_conquered_end",
					  )
	 EndNode(
			 id = "move_into_conquered_end",
			 text = "End of Battle",
			 )


	 PerformAction(
				   id = "end_without_moving",
					  action = "Do not move any units into the conquered region.",
					  next = "end_without_moving_end",
					  )
	 EndNode(
			 id = "end_without_moving_end",
			 text = "End of Battle",
			 )


	 BinaryCondition(
					 id = "press_on",
					 condition = """
					 A field battle was fought.
					 """,
					 next_true = "aggressive_if_continue",
					 next_false = "mili_strat",
					 )
	 CheckStrategy(
				   id = "mili_strat",
				   strategy = "military",
				   next_true = "aggressive_if_continue",
				   next_false = "press_on_2",
				   )
	 BinaryCondition(
					 id = "press_on_2",
					 condition = """
					 The Fellowship is on the Mordor track.
					 """,
					 next_true = "another_round_if_possible",
					 next_false = "no_more_round",
					 )
	 BinaryCondition(
					 id = "aggressive_if_continue",
					 condition = """
					 The Shadow army is *aggressive* and, if a siege battle is fought, would remain *aggressive* after an Elite downgrade to continue the battle.
					 """,
					 next_true = "another_round_if_possible",
					 next_false = "no_more_round_2",
					 )
	 BinaryCondition(
					 id = "another_round_if_possible",
					 condition = "A siege battle is fought and the Shadow army have no Elites left",
					 next_true = "no_more_round_2",
					 next_false = "one_more_round",
					 )
	 PerformAction(
				   id = "one_more_round",
				   action = "Continue the battle, downgrade an Elite if necessary.",
				   next = "one_more_round_return",
				   )
	 ReturnFromGraph(id = "one_more_round_return")


	 PerformAction(
				   id = "no_more_round",
				   action = "End battle",
				   next = "no_more_round_end",
				   )
	 EndNode(
			 id = "no_more_round_end",
			 text = "End of Battle",
			 )

	 PerformAction(
				   id = "no_more_round_2",
				   action = "End battle",
				   next = "no_more_round_end_2",
				   )
	 EndNode(
			 id = "no_more_round_end_2",
			 text = "End of Battle",
			 )

	 ]
end
