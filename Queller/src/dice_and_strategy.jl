################################################################################

module Strategy

@enum Choice begin
	Military
	Corruption
end

function Base.string(s::Choice)
	s == Military && return "military"
	s == Corruption && return "corruption"
	return nothing
end

function parse(s::AbstractString)
	for strat in instances(Choice)
		s == string(strat) && return strat
	end
	return nothing
end

end

function StrategyChoice(s::AbstractString)
	strat = Strategy.parse(s)
	isnothing(strat) && error("\"$(s)\" is not a valid strategy.")
	return strat
end

################################################################################

module Die

@enum Face begin
	Character
	Army
	Muster
	ArmyMuster
	Event
	# Eye # Not really used
	# WillOfTheWest # Not used
end

struct FaceInfo
	str::String
	c::Char
	article::String
end

const FaceInfos = Dict(
	Character => FaceInfo("Character Die",'C',"a"),
	Army => FaceInfo("Army Die",'A',"an"),
	Muster => FaceInfo("Muster Die",'M',"a"),
	ArmyMuster => FaceInfo("Muster/Army Die",'H',"a"),
	Event => FaceInfo("Event Die",'P',"an"),
	# Eye => FaceInfo("Eye",'E',"an"),
	# WillOfTheWest => FaceInfo("Will of the West",'W',"a"),
	)

article(f::Face) = FaceInfos[f].article

Base.string(f::Face) = FaceInfos[f].str
char(f::Face) = FaceInfos[f].c

function parse(c::Char)
	c = uppercase(c)
	for f in instances(Face)
		c == char(f) && return f
	end
	return nothing
end

function parse(s::AbstractString)
	s = filter(!isspace, collect(s)) # remove any spaces
	fs = parse.(s)
	(isempty(s) || any(isnothing.(fs))) && return nothing
	return fs
end

end

function DieFace(c)
	f = Die.parse(c)
	isnothing(f) && error("\'$(c)\' is not a valid die.")
	return f
end

