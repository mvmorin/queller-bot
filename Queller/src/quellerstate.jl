################################################################################

struct ActiveDie
	die::Die.Face
	use_as::Die.Face
	use_modt::Bool
	use_ring::Bool

	used::Bool
end

ActiveDie(die, use_as, use_modt, use_ring) = ActiveDie(die, use_as, use_modt, use_ring, false)
use_active_die(d) = ActiveDie(d.die, d.use_as, d.use_modt, d.use_ring, true)

function Base.string(d::ActiveDie)
	d.die == d.use_as && return string(d.die)

	text = "$(string(d.die)) as $(string(d.use_as))"
	d.use_modt && return text*" by using the Messenger of the Dark Tower ability"
	d.use_ring && return text*" by using an Elven Ring"
	return text
end

function get_active_die(die, available_dice, strategy, may_use_modt, may_use_ring)
	die in available_dice && return ActiveDie(die,die,false,false)

	(Die.ArmyMuster in available_dice) && (die == Die.Army || die == Die.Muster) && return ActiveDie(Die.ArmyMuster,die,false,false)
	(Die.Muster in available_dice) && (die == Die.Army && may_use_modt) && return ActiveDie(Die.Muster,die,true,false)

	strategy == Strategy.Military && (discardable_dice = [Die.Character, Die.Event])
	strategy == Strategy.Corruption && (discardable_dice = [Die.Army, Die.Muster, Die.ArmyMuster, Die.Event])

	discardable_dice = intersect(available_dice, discardable_dice)
	may_use_ring && !isempty(discardable_dice) && return ActiveDie(rand(discardable_dice),die,false,true)

	return nothing
end


################################################################################

mutable struct QuellerState
	strategy::Strategy.Choice

	active_die::Union{ActiveDie,Nothing}
	available_dice::Vector{Die.Face}

	ring_available::Bool
	modt_available::Bool
end

function QuellerState()
	strategy = rand(instances(Strategy.Choice))

	active_die = nothing
	available_dice = Vector{Die.Face}()

	ring_available = false
	modt_available = false

	QuellerState(strategy,active_die,available_dice,ring_available,modt_available)
end


################################################################################

mutable struct CheckStrategy <: StateInteractionNode
	id::String
	strategy::Strategy.Choice
	n_true::Node
	n_false::Node

	CheckStrategy(strategy) = (obj = new(); obj.strategy = StrategyChoice(strategy); obj)
end
getnext!(n::CheckStrategy, state) = (state.strategy == n.strategy ? n.n_true : n.n_false)
setnext!(n::CheckStrategy, name::Symbol, next::Node) = setfield!(n,name,next)

getmsg(n::CheckStrategy) = "The $(string(n.strategy)) strategy is used."
getmsg(n::CheckStrategy, state) = "The $(string(n.strategy)) strategy is used: $(state.strategy == n.strategy)"


################################################################################

mutable struct SetStrategy <: StateInteractionNode
	id::String
	strategy::Strategy.Choice
	next::Node

	SetStrategy(strategy) = (obj = new(); obj.strategy = StrategyChoice(strategy); obj)
end
setnext!(n::SetStrategy, next::Node) = (n.next = next)
getnext!(n::SetStrategy, state) = (state.strategy = n.strategy; n.next)

getmsg(n::SetStrategy) = "Set Queller strategy to $(string(n.strategy))."


################################################################################

mutable struct SetActiveDie <: StateInteractionNode
	id::String
	next::Node
	no_die::Node

	die::Die.Face
	may_use_ring::Bool

	SetActiveDie(die; may_use_ring=false) = (obj = new(); obj.die = DieFace(die); obj.may_use_ring = may_use_ring; obj)
end
setnext!(n::SetActiveDie, name::Symbol, next::Node) = setfield!(n,name,next)

function get_active_die(n::SetActiveDie,state)
	!isnothing(state.active_die) && state.active_die.used && error("Trying to set an active die when a die already have been used.")
	return get_active_die(n.die, state.available_dice, state.strategy, state.modt_available, state.ring_available && n.may_use_ring)
end

function getnext!(n::SetActiveDie,state)
	state.active_die = get_active_die(n, state)
	return isnothing(state.active_die) ? n.no_die : n.next
end

getmsg(n::SetActiveDie, state) = "The active die is set to: $(string(get_active_die(n,state)))"

function getmsg(n::SetActiveDie)
	prio_list = [string(n.die)]
	if n.die == Die.Army
		push!(prio_list, "$(string(Die.ArmyMuster)) as $(string(Die.Army))")
		push!(prio_list, "$(string(Die.Muster)) and Messenger of the Dark Tower as $(string(Die.Army))")
	elseif n.die == Die.Muster
		push!(prio_list, "$(string(Die.ArmyMuster)) as a $(string(Die.Muster))")
	end

	n.may_use_ring && push!(prio_list, "A random non-*preferred* die and an Elven Ring as $(string(n.die))")

	text = """
	Set the first matching die as the Active Die:

	"""
	for (i, d) in enumerate(prio_list)
		text *= "$(i). $(d)\n"
	end
	return text
end


################################################################################

mutable struct UseActiveDie <: StateInteractionNode
	id::String
	next::Node

	UseActiveDie() = new()
end
setnext!(n::UseActiveDie, next::Node) = (n.next = next)
function getnext!(n::UseActiveDie, state)
	isnothing(state.active_die) && error("No active die have been set before it is used.")

	state.active_die = use_active_die(state.active_die)

	i = findfirst(==(state.active_die.die), state.available_dice)
	state.available_dice = deleteat!(state.available_dice, i)
	return n.next
end

getmsg(n::UseActiveDie) = "Use the Active Die to:"
function getmsg(n::UseActiveDie, state)
	ad = state.active_die.die
	article = (ad == Die.Army || ad == Die.Event) ? "an" : "a"
	return "Use $(article) $(string(state.active_die)) to:"
end


################################################################################

mutable struct GetAvailableDice <: InteractiveNode
	id::String
	next::Node
	action::String

	GetAvailableDice(action = """
					 Roll all action dice not in the hunt box. Place all Eye results in the hunt box and input the remaining dice here.
					 """) = (obj = new(); obj.action = strip(action); obj)
end
setnext!(n::GetAvailableDice, next::Node) = (n.next = next)
getopt(n::GetAvailableDice) = [CMD.Dice()]
getnext!(n::GetAvailableDice, state, opt::CMD.Dice) = (state.available_dice = opt.dice; n.next)

function getmsg(n::GetAvailableDice)
	diefaces = instances(Die.Face)
	legends = Die.char.(diefaces).*": ".*string.(diefaces)

	return """
	$(n.action)

	$(strvec2str(legends))
	"""
end


################################################################################

mutable struct SetRingAvailable <: StateInteractionNode
	id::String
	next::Node
	ring_available::Bool

	SetRingAvailable(ring_available) = (obj = new(); obj.ring_available = ring_available; obj)
end
setnext!(n::SetRingAvailable, next::Node) = (n.next = next)
getnext!(n::SetRingAvailable, state) = (state.ring_available = n.ring_available; n.next)
getmsg(n::SetRingAvailable) = n.ring_available ? "Set an Elven ring as available." : "Set an Elven ring as not available."


################################################################################

mutable struct SetMoDTAvailable <: StateInteractionNode
	id::String
	next::Node
	modt_available::Bool

	SetMoDTAvailable(modt_available) = (obj = new(); obj.modt_available = modt_available; obj)
end
setnext!(n::SetMoDTAvailable, next::Node) = (n.next = next)
getnext!(n::SetMoDTAvailable, state) = (state.modt_available = n.modt_available; n.next)
getmsg(n::SetMoDTAvailable) = n.modt_available ? "Set 'Messenger of the Dark Tower' as available." : "Set 'Messenger of the Dark Tower' as not available."
