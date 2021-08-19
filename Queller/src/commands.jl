################################################################################

module CMD

abstract type Command end
abstract type AbortingCommand <: Command end
abstract type InputCommand <: Command end

minmatch(::Command) = 1
Base.string(c::Command) = split(lowercase(string(typeof(c))), '.')[end]

struct ResetAll <: AbortingCommand end
struct ResetPhase <: AbortingCommand end
struct Exit <: AbortingCommand end

struct Repeat <: Command end
struct Debug <: Command end
struct Help <: Command end

struct True <: InputCommand end
struct False <: InputCommand end
struct Option <: InputCommand opt end

Base.string(o::Option) = string(o.opt)

minmatch(::Debug) = 0
minmatch(::ResetAll) = 0
minmatch(::ResetPhase) = 7
minmatch(::Exit) = 0
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
