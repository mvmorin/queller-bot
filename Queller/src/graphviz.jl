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
		$(n.id) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(string(n)))\n($(escape_string(n.id)))"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::EndNode) =
	"""
		$(n.id) [shape=diamond, style=filled, fillcolor=red, label="$(escape_string(string(n)))"];

	"""

node2dot(n::DummyNode) =
	"""
		$(n.id) [shape=ellipse, style=filled, fillcolor=lightblue];
		$(n.id) -> $(n.next);

	"""

node2dot(n::JumpToGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(string(n)))\n($(escape_string(n.jump_graph)))"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::ReturnFromGraph) =
	"""
		$(n.id) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(string(n)))"];

	"""

################################################################################

node2dot(n::PerformAction) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=purple, label="$(escape_string(string(n)))"];
		$(n.id) -> $(n.next);

	"""

node2dot(n::BinaryCondition) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(string(n)))"];
		$(n.id) -> $(n.next_true) [label = "True"];
		$(n.id) -> $(n.next_false) [label = "False"];

	"""

function node2dot(n::MultipleChoice)
	dot_node = """
		$(n.id) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(string(n)))"];
	"""

	for (i, nx) in enumerate(n.nexts)
		dot_node *= """
			$(n.id) -> $(nx) [label = "$(i)"];
		"""
	end
	return dot_node*'\n'
end

################################################################################

node2dot(n::CheckStrategy) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=orange, label="$(escape_string(string(n)))"];
		$(n.id) -> $(n.next_true) [label="True"];
		$(n.id) -> $(n.next_false) [label="False"];

	"""

node2dot(n::SetActiveDie) =
	"""
		$(n.id) [shape=box, style=filled, fillcolor=pink, label="$(escape_string(string(n)))"];
		$(n.id) -> $(n.next) [label="Die Available"];
		$(n.id) -> $(n.next_no_die) [label="No Matching Die"];

	"""

node2dot(n::UseActiveDie) =
	"""
		$(n.id) [shape=hexagon, style=filled, fillcolor=pink, label="$(escape_string(string(n)))"];
		$(n.id) -> $(n.next);

	"""
