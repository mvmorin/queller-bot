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


################################################################################

struct IOParser
	cmds::Vector{CMD.Command}
	in::IO
	out::IO

	IOParser(cmds) = new(cmds, stdin, stdout)
end

Base.print(iop::IOParser,a...) = print(iop.out, a...)
Base.println(iop::IOParser,a...) = println(iop.out, a...)
function Base.readline(iop::IOParser)
	str = readline(iop.in)
	!isopen(iop.in) && error("Input stream closed")
	return lstrip(str)
end

function read_input(iop::IOParser, inputs::Vector{T}) where {T <: CMD.Command}
	prompt = isempty(inputs) ?
		"> " : "["*strvec2str(string.(inputs), '/')*"] > "
	print(iop, prompt)

	str = readline(iop)

	isempty(inputs) && isempty(str) && return nothing

	cmd = CMD.parse([inputs; iop.cmds], str)
	!isnothing(cmd) && return cmd

	!isempty(str) && println(iop,"Invalid input.")
	read_input(iop, inputs)
end

function read_dice(iop::IOParser)
	prompt = "[$(strvec2str(Die.char.(instances(Die.Face)),','))] > "
	print(iop, prompt)

	str = readline(iop)
	str = String(filter(!isspace, collect(str))) # remove any spaces

	cmd = CMD.parse(iop.cmds, str)
	!isnothing(cmd) && return cmd

	dice = Die.parse(str)
	!isnothing(dice) && return dice

	println(iop, "Invalid input.")
	read_dice(iop)
end

function display_message(iop::IOParser,msg,header="-"^10)
	println(iop, header)
	msg = lstrip(rstrip(msg))
	for p in split(msg, '\n')
		println(iop, wrap(p, width=50))
	end
end
