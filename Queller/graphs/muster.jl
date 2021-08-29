@graphs begin
	minion_prio = """
	Select a minion that can be reqruited.

	Priority:
	1. Saruman
	2. Witch King
	3. Mouth of Sauron
	"""

	recruit_saruman = """
	Recruit Saruman.
	"""

	recruit_wk = """
	Recruit the Witch King, place it in a valid region according to the following priority.

	1. Army is *mobile*
	2. *Target* nation is at war
	3. Army becomes mobile if the Witch King is added
	4. Opposing army does not contain Gandalf the White
	5. Opposing army does not contain hobbits
	6. Adjacent to *threat*
	7. Army that is conduction a siege
	8. Army adjacent to its *target*
	9. Highest *value* Shadow army
	10. Random
	"""

	recruit_mos = """
	Recruit Mouth of Sauron, place it in a valid region according to the following priority.

	1. Army than is conducting a siege.
	2. A *mobile* army
	3. Army becomes mobile if Mouth of Sauron is added
	4. Army that contains Saruman
	5. Army with the highest *value*
	6. Stronghold closest to army whose *target* is in a nation at war
	7. Stronghold closest to army whose *target* is in an active nation
	8. Stronghold closest to army whose *target* is in a passive nation
	9. Random
	"""


	################################################################################
	@node muster_minion = Start("Muster: Minion") -> m_2_reserved_check
	@node m_2_reserved_check = BinaryCondition("""
											   A die has been reserved for recruiting a minion as a last action.
											   """) -> [n_true = m_2_return, n_false = m_2]
	@node m_2 = BinaryCondition("""
								Minion can be recruited.
								""") -> [n_true = m_2_1, n_false = m_2_return]
	@node m_2_return = ReturnFromGraph() -> []

	@node m_2_1 = BinaryCondition("""
								  The Free Peoples' have a Will of the West die.
								  And, Gandalf the White has not been recruited.
								  And, no minion have been recruited.
								  """) -> [n_true = m_2_1_yes, n_false = m_2_minion_selection]
	@node m_2_1_yes = UseActiveDie() -> m_2_1_reserve
	@node m_2_1_reserve = PerformAction("""
										Set aside the die (and ring if necessary). Use this die as an last action to recruit a minion. Minion selection and placement can be made from the main menu.
										""") -> m_2_1_return
	@node m_2_1_return = ReturnFromGraph() -> []

	@node m_2_minion_selection = MultipleChoice(minion_prio) -> [m_2_saruman_die, m_2_wk_die, m_2_mos_die]

	@node m_2_saruman_die = UseActiveDie() -> m_2_saruman_placement
	@node m_2_saruman_placement = PerformAction(recruit_saruman) -> m_2_saruman_end

	@node m_2_wk_die = UseActiveDie() -> m_2_wk_placement
	@node m_2_wk_placement = PerformAction(recruit_wk) -> m_2_wk_end

	@node m_2_mos_die = UseActiveDie() -> m_2_mos_placement
	@node m_2_mos_placement = PerformAction(recruit_mos) -> m_2_mos_end

	@node m_2_saruman_end = End() -> []
	@node m_2_wk_end = End() -> []
	@node m_2_mos_end = End() -> []


	################################################################################
	@node muster_minion_selection = Start("Muster: Minion Selectoin") -> m_2_minion_selection_last
	@node m_2_minion_selection_last = MultipleChoice(minion_prio) -> [m_2_saruman_last, m_2_wk_last, m_2_mos_last]

	@node m_2_saruman_last = PerformAction(recruit_saruman) -> m_2_saruman_end_last
	@node m_2_wk_last = PerformAction(recruit_wk) -> m_2_wk_end_last
	@node m_2_mos_last = PerformAction(recruit_mos) -> m_2_mos_end_last

	@node m_2_saruman_end_last = End() -> []
	@node m_2_wk_end_last = End() -> []
	@node m_2_mos_end_last = End() -> []



	################################################################################
	@node muster_politics = Start("Muster: Politics") -> m_3
	@node m_3 = BinaryCondition("A Shadow nation is not at war.") -> [n_true = m_3_yes, n_false = m_3_return]
	@node m_3_return = ReturnFromGraph() -> []

	@node m_3_yes = UseActiveDie() -> m_3_action
	@node m_3_action = PerformAction("""
									 Move a nation down one step on the political track.

									 Priority:
									 1. Isengard
									 2. Sauron
									 3. Southrons and Easterlings
									 """) -> m_3_end
	@node m_3_end = End() -> []





	################################################################################
	@node muster_muster = Start("Muster: Muster") -> m_4
	@node m_4 = BinaryCondition("A card that musters is *playable*.") -> [n_true = m_4_die, n_false = m_5]
	@node m_4_die = UseActiveDie() -> m_4_action
	@node m_4_action = PerformAction("""
									 Play a *playable* muster card.

									 Priority:
									 1. Ascending order of initiative
									 2. Random
									 """) -> m_4_end
	@node m_4_end = End() -> []

	@node m_5 = BinaryCondition("""
								Muster is possible.
								""") -> [n_true = m_6, n_false = m_return]
	@node m_return = ReturnFromGraph() -> []

	@node m_6 = BinaryCondition("Muster can create an *exposed* region.") -> [n_true = m_6_die, n_false = m_7]
	@node m_6_die = UseActiveDie() -> m_6_action
	@node m_6_action = PerformAction("""
									 *Focus* priority:
									 1. Region which creates an *exposed* region
									 2. Random

									 Muster:
									 *Primary*: Elite
									 *Secondary*: Regular

									 If unit is unavailable, rotate as:
									 Elite -> Regular -> Nazgûl -> Elite
									 """) -> m_6_end
	@node m_6_end = End() -> []


	@node m_7 = BinaryCondition("""
								The Fellowship is adjacent to, or in, a region it is possible to muster in.
								And, the progress put the Fellowship outside Mordor.
								And, no army is adjacent to the Fellowship's current region.
								""") -> [n_true = m_7_die, n_false = m_8]
	@node m_7_die = UseActiveDie() -> m_7_action
	@node m_7_action = PerformAction("""
									 *Focus* priority:
									 1. The Fellowship's current region

									 Muster:
									 *Primary*: Regular
									 *Secondary*: Nazgûl

									 If unit is unavailable, rotate as:
									 Elite -> Regular -> Nazgûl -> Elite
									 """) -> m_7_end
	@node m_7_end = End() -> []


	@node m_8 = BinaryCondition("Muster is possible in a region containing a Shadow army.") -> [n_true = m_8_die, n_false = m_9]
	@node m_8_die = UseActiveDie() -> m_8_action
	@node m_8_action = PerformAction("""
									 *Focus* priority:
									 1. Army is *mobile*
									 2. Army's *target* is a nation at war
									 3. Army becomes mobile if the Witch King is added
									 4. Opposing army does not contain Gandalf the White
									 5. Army with the highest *value*
									 6. Random

									 Muster:
									 *Primary*: Regular
									 *Secondary*: Nazgûl

									 If unit is unavailable, rotate as:
									 Elite -> Regular -> Nazgûl -> Elite
									 """) -> m_8_end
	@node m_8_end = End() -> []


	@node m_9 = BinaryCondition("Less than 6 Nazgûl in play.") -> [n_true = m_10_yes, n_false = m_10_no]
	@node m_10_yes = UseActiveDie() -> m_10_yes_action
	@node m_10_yes_action = PerformAction("""
										  *Focus* priority:
										  1. Closest to army whose *target* is in a nation at war
										  2. Closest to army whose *target* is in an active nation.
										  3. Closest to a *mobile* army
										  4. Closest to army whose *target* is in a passive nation.
										  5. Random

										  Muster:
										  *Primary*: Nazgûl
										  *Secondary*: Nazgûl

										  If unit is unavailable, rotate as:
										  Elite -> Regular -> Nazgûl -> Elite
										  """) -> m_10_end_yes
	@node m_10_end_yes = End() -> []

	@node m_10_no = UseActiveDie() -> m_10_no_action
	@node m_10_no_action = PerformAction("""
										 *Focus* priority:
										 1. Closest to army whose *target* is in a nation at war
										 2. Closest to army whose *target* is in an active nation.
										 3. Closest to a *mobile* army
										 4. Closest to army whose *target* is in a passive nation.
										 5. Random

										 Muster:
										 *Primary*: Elite
										 *Secondary*: Nazgûl

										 If unit is unavailable, rotate as:
										 Elite -> Regular -> Nazgûl -> Elite
										 """) -> m_10_end_no
	@node m_10_end_no = End() -> []




	################################################################################

	@node muster_card = Start("Muster: Card") -> m_c_6
	@node m_c_6 = BinaryCondition("Muster can create an *exposed* region.") -> [n_true = m_c_6_action, n_false = m_c_7]
	@node m_c_6_action = PerformAction("""
									   *Focus* priority:
									   1. Region which creates an *exposed* region
									   2. Random

									   Muster:
									   *Primary*: Units according to card
									   *Secondary*: Units according to card
									   """) -> m_c_6_end
	@node m_c_6_end = End() -> []

	@node m_c_7 = BinaryCondition("""
								  The Fellowship is adjacent to, or in, a region it is possible to muster in.
								  And, the progress put the Fellowship outside Mordor.
								  And, no army is adjacent to the Fellowship's current region.
								  """) -> [n_true = m_c_7_action, n_false = m_c_8]
	@node m_c_7_action = PerformAction("""
									   *Focus* priority:
									   1. The Fellowship's current region

									   Muster:
									   *Primary*: Units according to card
									   *Secondary*: Units according to card
									   """) -> m_c_7_end
	@node m_c_7_end = End() -> []


	@node m_c_8 = BinaryCondition("""
								  Muster is possible in a region containing a Shadow army.
								  """) -> [n_true = m_c_8_action, n_false = m_c_9]
	@node m_c_8_action = PerformAction("""
									   *Focus* priority:
									   1. Army is *mobile*
									   2. Army's *target* is a nation at war
									   3. Army becomes mobile if the Witch King is added
									   4. Opposing army does not contain Gandalf the White
									   5. Army with the highest *value*
									   6. Random

									   Muster:
									   *Primary*: Units according to card
									   *Secondary*: Units according to card
									   """) -> m_c_8_end
	@node m_c_8_end = End() -> []


	@node m_c_9 = PerformAction("""
								*Focus* priority:
								1. Closest to army whose *target* is in a nation at war
								2. Closest to army whose *target* is in an active nation.
								3. Closest to a *mobile* army
								4. Closest to army whose *target* is in a passive nation.
								5. Random

								Muster:
								*Primary*: Units according to card
								*Secondary*: Units according to card
								""") -> m_c_9_end
	@node m_c_9_end = End() -> []

end
