@graphs begin
	@node phase_4 = Start() -> p4_roll
	@node p4_roll = GetAvailableDice("""
									 Roll all action dice not in the hunt box. Place all Eye results in the hunt box and input the remaining dice.
									 """) -> p4_end
	@node p4_end = End("End of Phase") -> []

	@node adjust_dice = Start() -> adjust_roll
	@node adjust_roll = GetAvailableDice() -> adjust_end
	@node adjust_end = End() -> []
end
