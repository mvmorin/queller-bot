let
	[
	 ################################################################################
	 StartNode(
			   id = "event_cards_preferred",
			   text = "Event Cards: Preferred",
			   next = "ep_1",
			   )
	 BinaryCondition(
					 id = "ep_1",
					 condition = """
					 A *preferred* card is *playable*.
					 """,
					 next_true = "ep_1_yes",
					 next_false = "ep_return",
					 )
	 ReturnFromGraph(
					 id = "ep_return",
					 )
	 UseActiveDie(
				  id = "ep_1_yes",
				  next = "ep_1_action",
				  )
	 PerformAction(
				   id = "ep_1_action",
				   action = """
				   Play a *playable* *preferred* card.

				   Priority:
				   1. Ascending Order of Initiative
				   2. Random
				   """,
				   next = "ep_1_end"
				   )
	 EndNode(id = "ep_1_end")


	 ################################################################################
	 StartNode(
			   id = "event_cards_general",
			   text = "Event Cards: General",
			   next = "eg_1",
			   )
	 BinaryCondition(
					 id = "eg_1",
					 condition = """
					 Holding less than 4 cards.
					 """,
					 next_true = "eg_1_yes",
					 next_false = "eg_2",
					 )
	 UseActiveDie(
				  id = "eg_1_yes",
				  next = "eg_1_action",
				  )
	 PerformAction(
				   id = "eg_1_action",
				   action = """
				   Draw a *preferred* card.
				   """,
				   next = "eg_1_end"
				   )
	 EndNode(id = "eg_1_end")


	 BinaryCondition(
					 id = "eg_2",
					 condition = """
					 A card is *playable*.
					 """,
					 next_true = "eg_2_yes",
					 next_false = "eg_3",
					 )
	 UseActiveDie(
				  id = "eg_2_yes",
				  next = "eg_2_action",
				  )
	 PerformAction(
				   id = "eg_2_action",
				   action = """
				   Play a *playable* card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """,
				   next = "eg_2_end"
				   )
	 EndNode(id = "eg_2_end")


	 UseActiveDie(
				  id = "eg_3",
				  next = "eg_3_action",
				  )
	 PerformAction(
				   id = "eg_3_action",
				   action = """
				   Draw a *preferred* card.
				   """,
				   next = "eg_3_discard",
				   )
	 BinaryCondition(
					 id = "eg_3_discard",
					 condition = """
					 Holding more than 6 cards.
					 """,
					 next_true = "eg_3_discard_yes",
					 next_false = "eg_3_discard_no",
					 )
	 PerformAction(
				   id = "eg_3_discard_yes",
				   action = """
				   Discard down to 6 cards.

				   Priority:
				   1. Not *preferred* card
				   2. Doesn't use the term "Fellowship revealed"
				   3. Doesn't place a tile
				   4. Ascending order of initiative
				   5. Random
				   """,
				   next = "eg_3_discard_yes_end",
				   )
	 EndNode(id = "eg_3_discard_yes_end")
	 EndNode(id = "eg_3_discard_no")


	 ################################################################################
	 StartNode(
			   id = "event_cards_corruption",
			   text = "Event Cards: Corruption",
			   next = "ec_1",
			   )
	 BinaryCondition(
					 id = "ec_1",
					 condition = """
					 An "Fellowship revealed" card
					 is *playable*.
					 """,
					 next_true = "ec_1_yes",
					 next_false = "ec_2",
					 )
	 UseActiveDie(
				  id = "ec_1_yes",
				  next = "ec_1_action",
				  )
	 PerformAction(
				   id = "ec_1_action",
				   action = """
				   Play a *playable* "Fellowship revealed" card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """,
				   next = "ec_1_end"
				   )
	 EndNode(id = "ec_1_end")


	 BinaryCondition(
					 id = "ec_2",
					 condition = """
					 A card that adds corruption or adds a hunt tile is *playable*.
					 """,
					 next_true = "ec_2_yes",
					 next_false = "ec_3",
					 )
	 UseActiveDie(
				  id = "ec_2_yes",
				  next = "ec_2_action",
				  )
	 PerformAction(
				   id = "ec_2_action",
				   action = """
				   Play a *playable* card which adds corruption or adds a hunt tile.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """,
				   next = "ec_2_end"
				   )
	 EndNode(id = "ec_2_end")


	 BinaryCondition(
					 id = "ec_3",
					 condition = """
					 Holding less than 4 cards.
					 """,
					 next_true = "ec_3_yes",
					 next_false = "ec_return",
					 )
	 UseActiveDie(
				  id = "ec_3_yes",
				  next = "ec_3_action",
				  )
	 PerformAction(
				   id = "ec_3_action",
				   action = """
				   Draw a character card.
				   """,
				   next = "ec_3_end"
				   )
	 EndNode(id = "ec_3_end")


	 ReturnFromGraph(
					 id = "ec_return",
					 )


	 ################################################################################
	 StartNode(
			   id = "event_cards_resolve_effect",
			   text = "Event Cards: Resolve Effect",
			   next = "er_select_card_effect_choice",
			   )
	 MultipleChoice(
					id = "er_select_card_effect_choice",
					conditions = """
					Select card effect to resolve.

					1. Region selection for muster
					2. Army selection for movement or attack
					3. Hunt allocation
					4. No effect, return to Phase 5 menu
					""",
					nexts = [
							 "er_muster",
							 "er_army",
							 "er_hunt",
							 "er_resolve_end",
							 ],
					)
	 JumpToGraph(
				 id = "er_muster",
				 text = "Muster: Card",
				 jump_graph = "muster_card",
				 next = "er_resolve_end",
				 )
	 JumpToGraph(
				 id = "er_army",
				 text = "Movement and Attack:\nCard",
				 jump_graph = "movement_attack_card",
				 next = "er_resolve_end",
				 )
	 PerformAction(
				   id = "er_hunt",
				   next = "er_resolve_end",
				   action = """
				   For each die that is possible to add to the hunt pool, roll a d6. On a 4+, add it to the hunt pool. It is only possible to add a die to the hunt pool if it is not a *preferred* die.
				   """,
				   )
	 EndNode(
			 id = "er_resolve_end",
			 )

	 ]
end
