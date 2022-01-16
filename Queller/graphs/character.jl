@graphs begin
	move_wk_cond = """
	The Witch King is not in an *mobile* army but is able to join or create one.
	"""

	wk_prio = """
	Move the Witch King, place it in a valid region with an army.

	Priority:
	1. Army is *mobile*
	2. Army's *target* is in nation at war
	3. Army becomes *mobile* if the Witch King is added
	4. Free Peoples' army at *target* or on the route to *target* does not contain Gandalf the White
	5. Free Peoples' army at *target* or on the route to *target* does not contain a hobbit
	6. Army is adjacent to a *threat*
	7. Army that is conduction a siege
	8. Army is adjacent to its *target*
	9. Highest *value* Shadow army
	10. Random
	"""

	move_nazgul_cond = """
	No Nazgûls are in the Fellowship's region but they are able to move there.
	Or, a Nazgûl is in a non-*mobile* army but is able to join or create one.
	"""

	nazgul_prio = """
	Gather all Nazgûl and place them one at the time.

	Priority:
	1. One, and only one, in the Fellowship's region
	2. Army with leadership *value* less than the number of army units and less than 5
	3. Army which contain the Which King
	4. Shadow stronghold under siege
	5. *Mobile* army
	6. Army adjacent to *threat*
	7. Army whose *target* nation is active
	8. Army that becomes *mobile* if Nazgûl is added
	9. Army not sieging
	10. Army that is adjacent to its *target*
	11. Highest *value* shadow army
	12. Random
	"""

	move_mos_cond = """
	Mouth of Souron is not in a *mobile* army.
	"""

	mos_prio = """
	Move Mouth of Sauron.

	Priority:
	1. Towards army with leadership *value* less than the number of army units and 5
	2. Towards *mobile* army
	3. Towards army adjacent to its *target*
	4. Army which can be reach with this die
	5. Towards closest army
	6. Random
	"""

	################################################################################
	@node character_army = Start() -> lc_1

	@node lc_1 = BinaryCondition("""
								 An *aggressive* army with the Witch King or maximum leadership is adjacent to its *target*.
								 """) -> [n_true = lc_1_yes, n_false = lc_2]
	@node lc_1_yes = UseActiveDie() -> lc_1_action
	@node lc_1_action = PerformAction("""
									  Attack according to the latest statement. Select army at random if several can perform such an attack.
									  """) -> lc_1_end
	@node lc_1_end = End() -> []

	@node lc_2 = BinaryCondition("""
								 A *mobile* army with leadership and a valid move/attack towards *target* exists.
								 """) -> [n_true = lc_2_yes, n_false = lc_3]
	@node lc_2_yes = JumpToGraph("movement_attack_basic") -> lc_3


	################################################################################
	@node character_move = Start() -> lc_3
	@node lc_3 = BinaryCondition("""
								 A Nazgûl or the Witch King is in play.
								 """) -> [n_true = lc_wk, n_false = lc_3_no]
	@node lc_3_no = JumpToGraph("event_cards_preferred") -> lc_3_return
	@node lc_3_return = ReturnFromGraph() -> []


	########################################
	@node character_which_king = Start() -> lc_wk_yes

	@node lc_wk = BinaryCondition(move_wk_cond) -> [n_true = lc_wk_yes, n_false = lc_naz_1]
	@node lc_wk_yes = UseActiveDie() -> lc_wk_action
	@node lc_wk_action = PerformAction(wk_prio) -> lc_naz_2


	########################################
	@node lc_naz_1 = BinaryCondition(move_nazgul_cond) -> [n_true = lc_naz_1_yes, n_false = lc_mos_1]
	@node lc_naz_1_yes = UseActiveDie() -> lc_naz_1_action
	@node lc_naz_1_action = PerformAction(nazgul_prio) -> lc_mos_2

	@node lc_naz_2 = BinaryCondition(move_nazgul_cond) -> [n_true = lc_naz_2_yes, n_false = lc_mos_3]
	@node lc_naz_2_yes = UseActiveDie() -> lc_naz_2_action
	@node lc_naz_2_action = PerformAction(nazgul_prio) -> lc_mos_4


	########################################
	@node lc_mos_1 = BinaryCondition(move_mos_cond) -> [n_true = lc_mos_1_yes, n_false = lc_play_card]
	@node lc_mos_1_yes = UseActiveDie() -> lc_mos_1_action
	@node lc_mos_1_action = PerformAction(mos_prio) -> lc_mos_end_1

	@node lc_mos_2 = BinaryCondition(move_mos_cond) -> [n_true = lc_mos_2_yes, n_false = lc_mos_end_2]
	@node lc_mos_2_yes = UseActiveDie() -> lc_mos_2_action
	@node lc_mos_2_action = PerformAction(mos_prio) -> lc_mos_end_2

	@node lc_mos_3 = BinaryCondition(move_mos_cond) -> [n_true = lc_mos_3_yes, n_false = lc_mos_end_3]
	@node lc_mos_3_yes = UseActiveDie() -> lc_mos_3_action
	@node lc_mos_3_action = PerformAction(mos_prio) -> lc_mos_end_3

	@node lc_mos_4 = BinaryCondition(move_mos_cond) -> [n_true = lc_mos_4_yes, n_false = lc_mos_end_4]
	@node lc_mos_4_yes = UseActiveDie() -> lc_mos_4_action
	@node lc_mos_4_action = PerformAction(mos_prio) -> lc_mos_end_4

	@node lc_mos_end_1 = End() -> []
	@node lc_mos_end_2 = End() -> []
	@node lc_mos_end_3 = End() -> []
	@node lc_mos_end_4 = End() -> []


	########################################
	@node lc_play_card = JumpToGraph("event_cards_preferred") -> lc_play_card_return
	@node lc_play_card_return = ReturnFromGraph() -> []


	################################################################################
	@node character_wk_prio = Start() -> lc_wk_prio
	@node lc_wk_prio = PerformAction(wk_prio) -> lc_wk_prio_end
	@node lc_wk_prio_end = End() -> []


	################################################################################
	@node character_nazgul_prio = Start() -> lc_nazgul_prio
	@node lc_nazgul_prio = PerformAction(nazgul_prio) -> lc_nazgul_prio_end
	@node lc_nazgul_prio_end = End() -> []


	################################################################################
	@node character_mos_prio = Start() -> lc_mos_prio
	@node lc_mos_prio = PerformAction(mos_prio) -> lc_mos_prio_end
	@node lc_mos_prio_end = End() -> []
end
