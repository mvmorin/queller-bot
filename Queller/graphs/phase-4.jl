@graphs begin
	@node phase_4 = Start() -> p4_roll
	@node p4_roll = GetAvailableDice() -> p4_end
	@node p4_end = End("End of Phase") -> []

	@node adjust_dice = Start() -> adjust_roll
	@node adjust_roll = GetAvailableDice("""
										 Input the available action dice
										 """) -> adjust_end
	@node adjust_end = End() -> []
end
