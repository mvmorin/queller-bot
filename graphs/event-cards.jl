let
	[
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








	 StartNode(
			   id = "event_cards_corruption",
			   text = "Event Cards: Corruption",
			   next = "ec_1",
			   )
	 BinaryCondition(
					id = "ec_1",
					condition = """
					An "if Fellowship revealed" card
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
				   Play a *playable* "if Fellowship revealed" card.

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
					Holding less than 4 cards?
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




	 ]
end
