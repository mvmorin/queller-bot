export graph2pdf,
	graph2ps

################################################################################

graph2ps(file_in, file_out="out.ps") = graph2format(file_in, "ps", file_out)
graph2pdf(file_in, file_out="out.pdf") = graph2format(file_in, "pdf", file_out)

function graph2format(file_in, format, file_out)
	g = load_graphs(file_in)[1] # Only take the first start point of the graph
	s = graph2dot(g)

	open(`dot -T$(format) -o $(file_out)`, write = true) do io
		print(io,s)
	end
end

function graph2dot(g::QuellerGraph)
	body = mapreduce(node2dot, *, values(g.nodes))

	return """
		digraph {
			rankdir=TB

		$(body)
		}
		"""
end

################################################################################

node2dot(n::StartNode) =
	"""
		$(n.id) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(n.text))\n($(escape_string(n.id)))"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::EndNode) =
	"""
		$(n.id) [shape=diamond, style=filled, fillcolor=red, label="$(escape_string(n.text))"];

	"""

node2dot(n::DummyNode) =
	"""
		$(n.id) [shape=ellipse, style=filled, fillcolor=lightblue];
		$(n.id) -> $(n.next);

	"""

node2dot(n::JumpToGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.text))\n($(escape_string(n.jump_graph)))"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::ReturnFromGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(n.jump_text))"];

	"""

################################################################################

node2dot(n::PerformAction) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="$(escape_string(n.action))"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::BinaryCondition) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(n.condition))"];
		$(n.id) -> $(n.next_true) [label = "True"];
		$(n.id) -> $(n.next_false) [label = "False"];

	"""

function node2dot(n::MultipleChoice)
	dot_node = """
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(n.conditions))"];
	"""

	for (i, nx) in enumerate(n.nexts)
		dot_node *= """
			$(n.id) -> $(nx) [label = "$(i)"];
		"""
	end
	return dot_node*'\n'
end

################################################################################

function node2dot(n::SetStrategy)
	text = """
	Use the $(string(n.strategy)) strategy
	until prompted otherwise.
	"""
	return """
		$(n.id) [shape=box, style=filled, fillcolor=orange, label="$(escape_string(text))"];
		$(n.id) -> $(n.next);

	"""
end

function node2dot(n::CheckStrategy)
	text = """
	The $(string(n.strategy)) strategy is used.
	"""
	return """
		$(n.id) [shape=box, style=filled, fillcolor=orange, label="$(escape_string(text))"];
		$(n.id) -> $(n.next_true) [label="True"];
		$(n.id) -> $(n.next_false) [label="False"];

	"""
end

################################################################################

node2dot(n::RollActionDice) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="Roll the action dice."];
		$(n.id) -> $(n.next);

	"""

node2dot(n::AvailableModifiers) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="Check if an elven ring\n or Messenger of the Dark\n Tower is available."];
		$(n.id) -> $(n.next);

	"""

function node2dot(n::SetActiveDie)
	prio_list = [string(n.die)]
	if n.die == Die.Army
		push!(prio_list, "$(string(Die.ArmyMuster)) as $(string(Die.Army))")
		push!(prio_list, "$(string(Die.Muster)) and Messenger of the Dark Tower as $(string(Die.Army))")
	elseif n.die == Die.Muster
		push!(prio_list, "$(string(Die.ArmyMuster)) as a $(string(Die.Muster))")
		push!(prio_list, "$(string(Die.Army)) and Messenger of the Dark Tower as $(string(Die.Muster))")
	end

	if n.may_use_ring
		push!(prio_list, "A random non-*preferred* die and an Elven Ring as $(string(n.die))")
	end


	text = """
	Set the first matching die as the Active Die:

	"""
	for (i, d) in enumerate(prio_list)
		text *= "$(i). $(d)\n"
	end

	return """
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="$(escape_string(text))"];
		$(n.id) -> $(n.next) [label="Die Available"];
		$(n.id) -> $(n.next_no_die) [label="No Matching Die"];

	"""
end

node2dot(n::UseActiveDie) =
	"""
		$(n.id) [shape=hexagon, style=filled, fillcolor=pink, label="Use the Active Die to:"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::SetRandomDie) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="Set a random die as the Active Die"];
		$(n.id) -> $(n.next);

	"""
