################################################################################

module CMD

abstract type Command end
abstract type AbortingCommand <: Command end
abstract type InputCommand <: Command end

minmatch(::Command) = 1
Base.string(c::Command) = split(lowercase(string(typeof(c))), '.')[end]

struct Reset <: AbortingCommand end
struct ResetPhase <: AbortingCommand end
struct Exit <: AbortingCommand end

struct Repeat <: Command end
struct Debug <: Command end
struct Help <: Command end

struct True <: InputCommand end
struct False <: InputCommand end
struct Option <: InputCommand opt end

Base.string(o::Option) = string(o.opt)

minmatch(::Debug) = 5
minmatch(::Reset) = 5
minmatch(::ResetPhase) = 6
minmatch(::Exit) = 4
minmatch(::Option) = 0

function match(s, cmd)
	str = string(cmd)
	length(s) > length(str) && return false
	matchlen = minmatch(cmd) == 0 ? length(str) : max(length(s), minmatch(cmd))
	s == str[1:matchlen]
end

function parse(cmds, s::AbstractString)
	s = lowercase(s)

	for cmd in cmds
		match(s, cmd) && return cmd
	end
end

end
