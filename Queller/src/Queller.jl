module Queller

export load_graphs,
	check_queller_graphs

################################################################################

not_unique(v, f=isequal) = filter(e -> (count(f.([e],v)) > 1), v)
strvec2str(v,sep='\n') = reduce((s,t) -> s*sep*t, v)

################################################################################

include("commands.jl")
include("dice_and_strategy.jl")
include("graph.jl")
include("crawler.jl")

################################################################################

function read_command(options; cmds=[])
	prompt = isempty(options) ?
		"> " : "["*strvec2str(string.(options), '/')*"] > "

	print(prompt)

	input = readline()
	isempty(options) && isempty(input) && return nothing

	cmd = CMD.parse([options; cmds], input)
	!isnothing(cmd) && return cmd

	println("Invalid input.")
	read_command(options, cmds = cmds)
end

################################################################################

pkg_dir = abspath(joinpath(dirname(pathof(@__MODULE__)),".."))

const GRAPH_SOURCES = [
	"$(pkg_dir)/graphs/phase-1.jl"
	"$(pkg_dir)/graphs/phase-2.jl"
	"$(pkg_dir)/graphs/phase-3.jl"
	"$(pkg_dir)/graphs/phase-4.jl"
	"$(pkg_dir)/graphs/select-action-corr.jl"
	"$(pkg_dir)/graphs/select-action-mili.jl"
	"$(pkg_dir)/graphs/threat-exposed.jl"
	"$(pkg_dir)/graphs/battle.jl"
	"$(pkg_dir)/graphs/character.jl"
	"$(pkg_dir)/graphs/event-cards.jl"
	"$(pkg_dir)/graphs/movement-attack.jl"
	"$(pkg_dir)/graphs/muster.jl"
	]

mutable struct ProgramState
	strategy
	dice
	active_die

	graphs

	debug_mode::Bool
end

function main()

end

function handle_general_command(cmd)

end

function phase1(state)

end

function phase2(state)

end

function phase3(state)

end

function phase4(state)

end

function phase5(state)

end


################################################################################

include("graphviz.jl")

function check_queller_graphs()
	graphs = load_graphs(GRAPH_SOURCES...)

	println("\nAll graphs in PostScript can be found in Queller/graph_output.")
	graph_output(f) = joinpath(pkg_dir, "graph_output", basename(f)*".ps")
	for f in GRAPH_SOURCES
		graph2ps(f, graph_output(f))
	end


	unjumped = get_graphs_not_jumped_to(values(graphs))
	println("\nGraphs that are not jumped to from another graph:\n$(strvec2str(unjumped))")
end


end
