@graphs begin
	@node phase_3 = Start() -> p3_strat
	@node p3_strat = CheckStrategy("military") -> [n_true=p3_mili_1, n_false=p3_corr_1]

	# Military
	@node p3_mili_1 = BinaryCondition("The Fellowship is on the Mordor track.") -> [n_true = p3_mili_1_yes, n_false = p3_mili_2]
	@node p3_mili_1_yes = PerformAction("Assign the maximum allowed number of dice to the hunt pool.") -> p3_mili_end_phase

	@node p3_mili_2 = BinaryCondition("The Fellowship's progress is greater than 5.") -> [n_true = p3_mili_2_yes, n_false = p3_mili_3]
	@node p3_mili_2_yes = PerformAction("Assign 2 dice to the hunt pool.") -> p3_mili_end_phase

	@node p3_mili_3 = BinaryCondition("The Fellowship is on the starting position and its progress is 0.") -> [n_true = p3_mili_3_yes, n_false = p3_mili_3_no]
	@node p3_mili_3_yes = PerformAction("Assign 0 dice to the hunt pool.") -> p3_mili_end_phase
	@node p3_mili_3_no = PerformAction("Assign 1 dice to the hunt pool.") -> p3_mili_end_phase

	@node p3_mili_end_phase = End("End of Phase") -> []

	# Corruption
	@node p3_corr_1 = BinaryCondition("The Fellowship is on the starting position and its progess is 0.") -> [n_true = p3_corr_1_yes, n_false = p3_corr_2]
	@node p3_corr_1_yes = PerformAction("Roll a d6. On 4+, assign 1 die to the hunt pool, otherwise do nothing.") -> p3_corr_end_phase

	@node p3_corr_2 = BinaryCondition( " The Fellowship is on the Mordor track.  ") -> [n_true = p3_corr_2_yes, n_false = p3_corr_3]
	@node p3_corr_2_yes = PerformAction( " Assign the maximum allowed number of dice to the hunt pool.  ") -> p3_corr_end_phase

	@node p3_corr_3 = BinaryCondition("""
									  A *mobile* army is adjacent to its *target* which provides enough victory points to win the game.
									  Or, the Shadow have 7 dice.
									  """
									  ) -> [n_true = p3_corr_3_yes, n_false = p3_corr_4]
	@node p3_corr_3_yes = PerformAction( " Assign 1 die to the hunt pool.  ") -> p3_corr_end_phase

	@node p3_corr_4 = BinaryCondition( " The Fellowship's progress is greater than 4.  ") -> [n_true = p3_corr_4_yes, n_false = p3_corr_5]
	@node p3_corr_4_yes = PerformAction( " Assign 2 dice to the hunt pool.  ") -> p3_corr_end_phase

	@node p3_corr_5 = BinaryCondition("""
									  The Fellowship's shortest path to Mordor leads via a Shadow stronghold and the progress allows them to pass it or be within 2 steps from it.
									  """) -> [n_true = p3_corr_5_yes, n_false = p3_corr_5_no]
	@node p3_corr_5_yes = PerformAction("Assign 2 dice to the hunt pool.") -> p3_corr_end_phase
	@node p3_corr_5_no = PerformAction("Assign 1 dice to the hunt pool.") -> p3_corr_end_phase

	@node p3_corr_end_phase = End("End of Phase") -> []
end
