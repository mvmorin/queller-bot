@graphs begin
	@node phase_5 = Start() -> ring_check

	@node ring_check = BinaryCondition("The Shadow has an Elven ring.") -> [n_true=ring_available, n_false=ring_not_available]
	@node ring_available = SetRingAvailable(true) -> modt_check
	@node ring_not_available = SetRingAvailable(false) -> modt_check

	@node modt_check = BinaryCondition("""
									   The Mouth of Sauron is recruited and his "Messenger of the Dark Tower" ability have not been used this turn.
									   """) -> [n_true=modt_available, n_false=modt_not_available]
	@node modt_available = SetMoDTAvailable(true) -> p5_strat
	@node modt_not_available = SetMoDTAvailable(false) -> p5_strat

	@node p5_strat = CheckStrategy("military") -> [n_true=p5_mili, n_false=p5_corr]

	@node p5_mili = JumpToGraph("select_action_mili") -> p5_discard_check
	@node p5_corr = JumpToGraph("select_action_corr") -> p5_discard_check

	@node p5_discard_check = CheckStrategy("military") -> [n_true = p5_mili_discard, n_false = p5_corr_discard]
	@node p5_mili_discard = PerformAction("""
										  Queller failed to find an action. Discard a random Character or Event die if possible, otherwise discard a random die (do not discard a die set aside for later use).
										  """) -> p5_dice
	@node p5_corr_discard = PerformAction("""
										  Queller failed to find an action. Discard a random Army, Muster, Muster/Army or Event die if possible, otherwise discard a random die (do not discard a die set aside for later use).
										  """) -> p5_dice
	@node p5_dice = GetAvailableDice("""
									 Input the remaining available dice here (not counting dice set aside for later use).
									 """) -> p5_end

	@node p5_end = End("End of Phase") -> []
end
