################################################################################

module CMD

abstract type Command end

minmatch(::Command) = 1
Base.string(c::Command) = split(lowercase(string(typeof(c))), '.')[end]

struct True <: Command end
struct False <: Command end
struct Debug <: Command end
struct Reset <: Command end
struct ResetPhase <: Command end
struct Help <: Command end
struct Option <: Command opt end

Base.string(o::Option) = string(o.opt)

minmatch(::Reset) = 5
minmatch(::ResetPhase) = 6
minmatch(::Option) = 0

function match(s, cmd)
	str = string(cmd)
	length(s) > length(str) && return false
	matchlen = minmatch(cmd) == 0 ? length(str) : max(length(s), minmatch(cmd))
	s == str[1:matchlen]
end

function parse(cmds, s::String)
	s = lowercase(s)

	for cmd in cmds
		match(s, cmd) && return cmd
	end
end

end
