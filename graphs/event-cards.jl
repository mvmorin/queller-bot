let
	[
	 StartNode(
			   id = "event_cards_preferred",
			   text = "Event Cards: Preferred",
			   next = "ep_1",
			   )
	 YesNoCondition(
					id = "ep_1",
					condition = """
					A *preferred* card is *playable*.
					""",
					next_yes = "ep_1_yes",
					next_no = "ep_return",
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
				   next = "ep_1_resolve"
				   )
	 JumpToGraph(
				 id = "ep_1_resolve",
				 text = "Event Cards: Resolution",
				 next = "ep_1_end",
				 jump_graph = "event_cards_resolution",
				 )
	 EndNode(id = "ep_1_end")







	 StartNode(
			   id = "event_cards_general",
			   text = "Event Cards: General",
			   next = "eg_1",
			   )
	 YesNoCondition(
					id = "eg_1",
					condition = """
					Holding less than 4 cards.
					""",
					next_yes = "eg_1_yes",
					next_no = "eg_2",
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



	 YesNoCondition(
					id = "eg_2",
					condition = """
					A card is *playable*.
					""",
					next_yes = "eg_2_yes",
					next_no = "eg_3",
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
				   next = "eg_2_resolve"
				   )
	 JumpToGraph(
				 id = "eg_2_resolve",
				 text = "Event Cards: Resolution",
				 next = "eg_2_end",
				 jump_graph = "event_cards_resolution",
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
	 YesNoCondition(
					id = "eg_3_discard",
					condition = """
					Holding more than 6 cards.
					""",
					next_yes = "eg_3_discard_yes",
					next_no = "eg_3_discard_no",
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








	 StartNode(
			   id = "event_cards_corruption",
			   text = "Event Cards: Corruption",
			   next = "ec_1",
			   )
	 YesNoCondition(
					id = "ec_1",
					condition = """
					An "if Fellowship revealed" card
					is *playable*.
					""",
					next_yes = "ec_1_yes",
					next_no = "ec_2",
					)
	 UseActiveDie(
				  id = "ec_1_yes",
				  next = "ec_1_action",
				  )
	 PerformAction(
				   id = "ec_1_action",
				   action = """
				   Play a *playable* "if Fellowship revealed" card.

				   Priority:
				   1. Ascending order of initiative
				   2. Random
				   """,
				   next = "ec_1_resolve"
				   )
	 JumpToGraph(
				 id = "ec_1_resolve",
				 text = "Event Cards: Resolution",
				 next = "ec_1_end",
				 jump_graph = "event_cards_resolution",
				 )
	 EndNode(id = "ec_1_end")

	 YesNoCondition(
					id = "ec_2",
					condition = """
					A card that adds corruption or adds a hunt tile is *playable*.
					""",
					next_yes = "ec_2_yes",
					next_no = "ec_3",
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
				   next = "ec_2_resolve"
				   )
	 JumpToGraph(
				 id = "ec_2_resolve",
				 text = "Event Cards: Resolution",
				 next = "ec_2_end",
				 jump_graph = "event_cards_resolution",
				 )
	 EndNode(id = "ec_2_end")

	 YesNoCondition(
					id = "ec_3",
					condition = """
					Holding less than 4 cards?
					""",
					next_yes = "ec_3_yes",
					next_no = "ec_return",
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



	 StartNode(
			   id = "event_cards_resolution",
			   text = "Event Cards: Resolution",
			   next = "er_1",
			   )
	 ResolveCard(
				 id = "er_1",
				 next = "er_2",
				 )
	 MultipleChoice(
					id = "er_2",
					conditions = """
					Select card effect to resolve.

					1. No effect to resolve
					2. Region selection for muster
					3. Army selection for movement or attack
					4. Hunt allocation
					""",
					nexts = [
							 "er_no_effect",
							 "er_muster",
							 "er_army",
							 "er_hunt",
							 ],
					)
	 ReturnFromGraph(
					 id = "er_no_effect",
					 )
	 JumpToGraph(
				 id = "er_muster",
				 text = "Muster: Card",
				 next = "er_2",
				 jump_graph = "muster_card",
				 )
	 JumpToGraph(
				 id = "er_army",
				 text = "Movement and Attack:\nCard",
				 next = "er_2",
				 jump_graph = "movement_attack_card",
				 )
	 CheckStrategy(
				   id = "er_hunt",
				   strategy = "corruption",
				   next_true = "er_hunt_corr",
				   next_false = "er_hunt_mili",
				   )
	 JumpToGraph(
				 id = "er_hunt_corr",
				 text = "Phase 3: Corruption Strategy",
				 next = "er_2",
				 jump_graph = "phase_3_corr",
				 )
	 JumpToGraph(
				 id = "er_hunt_mili",
				 text = "Phase 3: Military Strategy",
				 next = "er_2",
				 jump_graph = "phase_3_mili",
				 )


	 ]
end
