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
					Is a playable
					*preferred*
					card held?
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
				   Play event card

				   Priority:
				   1. *Preferred* Event Card
				   2. Ascending Order of Initiative
				   """,
				   next = "ep_1_end"
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
					Is less than 4 cards held?
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
					Is a playable event card held?
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
				   Play event card.

				   Priority: Ascending order of initiative
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
	 YesNoCondition(
					id = "eg_3_discard",
					condition = """
					Is more than 6 card held?
					""",
					next_yes = "eg_3_discard_yes",
					next_no = "eg_3_discard_no",
					)
	 PerformAction(
				   id = "eg_3_discard_yes",
				   action = """
				   Discard event cards down to 6.

				   Priority:
				   1. Not *Preferred* Event Card
				   2. Doesn't use the term "Fellowship revealed"
				   3. Doesn't place a tile
				   4. Ascending order of initiative
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
					Is SP holding an "if
					Fellowship revealed" card?
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
				   Play an "if Fellowship revealed" card.

				   Priority: Ascending order of initiative
				   """,
				   next = "ec_1_end"
				   )
	 EndNode(id = "ec_1_end")

	 YesNoCondition(
					id = "ec_2",
					condition = """
					Is SP holding a card which
					can add corruption to the
					Fellowship or add a hunt
					tile?
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
				   Play a card which adds corruption or
				   adds a hunt tile

				   Priority: Ascending order of initiative
				   """,
				   next = "ec_2_end"
				   )
	 EndNode(id = "ec_2_end")

	 YesNoCondition(
					id = "ec_3",
					condition = """
					Is SP holding less than 4 event
					cards?
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
				   Draw a character event card
				   """,
				   next = "ec_3_end"
				   )
	 EndNode(id = "ec_3_end")

	 ReturnFromGraph(
					 id = "ec_return",
					 )



	 ]
end
