################################################################################

module CMD

using ..Die

abstract type Command end
abstract type AbortingCommand <: Command end
abstract type InputCommand <: Command end

struct ResetPhase <: AbortingCommand end
struct Exit <: AbortingCommand end
struct Phase <: AbortingCommand
	nbr
	max_nbr
end
Phase(max_nbr) = Phase(nothing,max_nbr)

struct Repeat <: Command end
struct Undo <: Command end
struct Help <: Command end

struct True <: InputCommand end
struct False <: InputCommand end
struct Option <: InputCommand opt end
struct Blank <: InputCommand end
struct Dice <: InputCommand dice end
Dice() = Dice(nothing)


########################################
Base.string(c::Command) = split(lowercase(string(typeof(c))), '.')[end]
Base.string(o::Option) = string(o.opt)

function Base.:(==)(a::Dice,b::Dice)
	isnothing(a.dice) && return true
	isnothing(b.dice) && return true
	return a.dice == b.dice
end


########################################
minmatch(::Command) = 1
minmatch(::AbortingCommand) = 0
minmatch(::ResetPhase) = 5
minmatch(::Option) = 0

function parse(cmd::Command, s::AbstractString)
	str = string(cmd)
	length(s) > length(str) && return nothing
	matchlen = minmatch(cmd) == 0 ? length(str) : max(length(s), minmatch(cmd))
	s == str[1:matchlen] ? cmd : nothing
end

parse(cmd::Dice, s::AbstractString) = (d = Die.parse(s); isnothing(d) ? nothing : Dice(d))
parse(cmd::Blank, s::AbstractString) = (isempty(strip(s)) ? Blank() : nothing)

function parse(cmd::Phase, s::AbstractString)
	s_parts = split(s)
	length(s_parts) != 2 && return nothing
	s_parts[1] != "phase" && return nothing

	nbr = tryparse(Int, s_parts[2])
	isnothing(nbr) && return nothing
	!(1 <= nbr <= cmd.max_nbr) && return nothing

	return Phase(nbr, cmd.max_nbr)
end


########################################
function parse(cmds::Vector{T}, s::AbstractString) where {T <: Command}
	s = lowercase(s)

	for cmd in cmds
		match = parse(cmd, s)
		!isnothing(match) && return match
	end
	return nothing
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
	return strip(str)
end

function read_input(iop::IOParser, options, prompt::String)
	print(iop, prompt)

	str = readline(iop)

	cmd = CMD.parse([iop.cmds; options], str)
	!isnothing(cmd) && return cmd

	!isempty(str) && println(iop,"Invalid input.")
	return read_input(iop, options, prompt)
end

function read_input(iop::IOParser, options::Vector{<:CMD.Command}, silent_options::Vector{<:CMD.Command})
	prompt = "["*strvec2str(string.(options), '/')*"] > "
	return read_input(iop, [options; silent_options], prompt)
end

function read_input(iop::IOParser, options::Vector{CMD.Dice}, silent_options::Vector{<:CMD.Command})
	prompt = "[$(strvec2str(Die.char.(instances(Die.Face)),','))] > "
	return read_input(iop, [options; silent_options], prompt)
end

function read_input(iop::IOParser, options::Vector{CMD.Blank}, silent_options::Vector{<:CMD.Command})
	return read_input(iop, [options; silent_options], "[Press enter to continue] > ")
end

function display_message(iop::IOParser,msg,header="-"^10)
	println(iop, header)
	msg = strip(msg)
	for p in split(msg, '\n')
		m = match(r"^\s*(?:[0-9]+\.|-|And,|Or,)\s+", p)
		list_item_indent = isnothing(m) ? 0 : length(m.match)
		println(iop, wrap(p, width=50, subsequent_indent=' '^list_item_indent))
	end
end
