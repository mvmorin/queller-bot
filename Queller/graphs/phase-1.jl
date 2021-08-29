@graphs begin
	# Military
	@node phase_1_mili = Start("Phase 1: Military Strategy") -> p1_mili_1
	@node p1_mili_1 = PerformAction("Recover action dice.") -> p1_mili_2
	@node p1_mili_2 = PerformAction("Draw event cards.") -> p1_mili_3
	@node p1_mili_3 = BinaryCondition("Holding more than 6 cards.") -> [n_true = p1_mili_discard, n_false = p1_mili_end]
	@node p1_mili_discard = PerformAction("""
										  Discard event cards down to 6.

										  Priority:
										  1. Doesn't use the term "Fellowship revealed"
										  2. Character card
										  3. Strategy card
										  4. Descending order of initiative
										  5. Doesn't place a tile
										  6. Random
										  """) -> p1_mili_end
	@node p1_mili_end = End("End of Phase") -> []

	# Corruption
	@node phase_1_corr = Start("Phase 1: Corruption Strategy") -> p1_corr_1
	@node p1_corr_1 = PerformAction("Recover action dice.") -> p1_corr_2
	@node p1_corr_2 = PerformAction("Draw event cards.") -> p1_corr_3
	@node p1_corr_3 = BinaryCondition("Holding more than 6 cards.") -> [n_true = p1_corr_discard, n_false = p1_corr_end_1]
	@node p1_corr_discard = BinaryCondition("Holding more than 1 strategy cards.") -> [n_true = p1_corr_discard_1, n_false = p1_corr_discard_2]
	@node p1_corr_discard_1 = PerformAction("""
											Discard event cards down to 6.

											Priority:
											1. Doesn't use the term "Fellowship revealed"
											2. Doesn't place a tile
											3. Strategy card
											4. Character card
											5. Descending order of initiative
											6. Random
											""") -> p1_corr_end_2
	@node p1_corr_discard_2 = PerformAction("""
											Discard event cards down to 6.

											Priority:
											1. Doesn't use the term "Fellowship revealed"
											2. Doesn't place a tile
											3. Character card
											4. Strategy card
											5. Descending order of initiative
											6. Random
											""") -> p1_corr_end_2
	@node p1_corr_end_1 = End("End of Phase") -> []
	@node p1_corr_end_2 = End("End of Phase") -> []
end
