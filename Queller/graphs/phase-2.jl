@graphs begin
	@node phase_2 = Start() -> p2_check
	@node p2_check = CheckStrategy("military") -> [n_true=p2_mili, n_false=p2_corr]

	# Military
	@node p2_mili = BinaryCondition("""
									The Shadow's victory points are less than the corruption points after the Free Peoples' have chosen whether to reveal.
									""") -> [n_true=p2_mili_change, n_false=p2_mili_end]
	@node p2_mili_change = SetStrategy("corruption") -> p2_mili_end

	@node p2_mili_end = End("End of Phase") -> []

	# Corruption
	@node p2_corr = BinaryCondition("""
									The corruption points are less than the Shadow's victory points after the Free Peoples' have chosen whether to reveal.
									""") -> [n_true=p2_corr_change, n_false=p2_corr_end]
	@node p2_corr_change = SetStrategy("military") -> p2_corr_end

	@node p2_corr_end = End("End of Phase") -> []

end
