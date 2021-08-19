################################################################################

module CMD

using ..Die

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
struct Blank <: InputCommand end
struct Dice <: InputCommand dice end
Dice() = Dice(nothing)

Base.string(o::Option) = string(o.opt)

minmatch(::Debug) = 0
minmatch(::ResetAll) = 0
minmatch(::ResetPhase) = 0
minmatch(::Exit) = 0
minmatch(::Option) = 0

function parse(cmd::Command, s::AbstractString)
	str = string(cmd)
	length(s) > length(str) && return nothing
	matchlen = minmatch(cmd) == 0 ? length(str) : max(length(s), minmatch(cmd))
	s == str[1:matchlen] ? cmd : nothing
end
parse(cmds::Dice, s::AbstractString) = (d = Die.parse(s); isnothing(d) ? nothing : Dice(d))
parse(cmds::Blank, s::AbstractString) = (isempty(lstrip(s)) ? Blank() : nothing)

function parse(cmds::Vector{T}, s::AbstractString) where {T <: Command}
	s = lowercase(s)

	for cmd in cmds
		match = parse(cmd, s)
		!isnothing(match) && return match
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

function read_input(iop::IOParser, options, prompt)
	print(iop, prompt)

	str = readline(iop)

	cmd = CMD.parse(iop.cmds,str)
	!isnothing(cmd) && return cmd

	cmd = CMD.parse(options, str)
	!isnothing(cmd) && return cmd

	!isempty(str) && println(iop,"Invalid input.")
	read_input(iop, options, prompt)
end

function read_input(iop::IOParser, options::Vector{T}) where {T <: CMD.Command}
	prompt = "["*strvec2str(string.(options), '/')*"] > "
	read_input(iop, options, prompt)
end

function read_input(iop::IOParser, options::Vector{CMD.Dice})
	prompt = "[$(strvec2str(Die.char.(instances(Die.Face)),','))] > "
	read_input(iop, options, prompt)
end

read_input(iop::IOParser, options::Vector{CMD.Blank}) = read_input(iop, options, "> ")

function display_message(iop::IOParser,msg,header="-"^10)
	println(iop, header)
	msg = lstrip(rstrip(msg))
	for p in split(msg, '\n')
		println(iop, wrap(p, width=50))
	end
end
