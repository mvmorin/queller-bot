export graph2pdf,
	graph2ps

################################################################################

graph2ps(file_in, file_out="out.ps") = graph2format(file_in, "ps", file_out)
graph2pdf(file_in, file_out="out.pdf") = graph2format(file_in, "pdf", file_out)

function graph2format(file_in, format, file_out)
	g = load_graphs_from_file(file_in)[1] # Only take the first start point of the graph
	s = graph2dot(g)

	open(`dot -T$(format) -o $(file_out)`, write = true) do io
		print(io,s)
	end
end

function graph2dot(g::QuellerGraph)
	body = mapreduce(node2dot, *, g.nodes)

	return """
		digraph {
			rankdir=TB

		$(body)
		}
		"""
end

################################################################################

node2dot(n::Start) =
	"""
		$(getid(n)) [shape=ellipse, style=filled, fillcolor=green, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::End) =
	"""
		$(getid(n)) [shape=diamond, style=filled, fillcolor=red, label="$(escape_string(getmsg(n)))"];

	"""

node2dot(n::Dummy) =
	"""
		$(getid(n)) [shape=ellipse, style=filled, fillcolor=lightblue];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::JumpToGraph) =
	"""
		$(getid(n)) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::ReturnFromGraph) =
	"""
		$(getid(n)) [shape=octagon, style=filled, fillcolor=grey, label="$(escape_string(getmsg(n)))"];

	"""

################################################################################

node2dot(n::PerformAction) =
	"""
		$(getid(n)) [shape=box, style=filled, fillcolor=purple, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::BinaryCondition) =
	"""
		$(getid(n)) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.n_true)) [label = "True"];
		$(getid(n)) -> $(getid(n.n_false)) [label = "False"];

	"""

function node2dot(n::MultipleChoice)
	dot_node = """
		$(getid(n)) [shape=box, style=filled, fillcolor=yellow, label="$(escape_string(getmsg(n)))"];
	"""

	for (i, nx) in enumerate(n.nexts)
		dot_node *= """
			$(getid(n)) -> $(getid(nx)) [label = "$(i)"];
		"""
	end
	return dot_node*'\n'
end

################################################################################

node2dot(n::CheckStrategy) =
	"""
		$(getid(n)) [shape=box, style=filled, fillcolor=orange, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.n_true)) [label="True"];
		$(getid(n)) -> $(getid(n.n_false)) [label="False"];

	"""

node2dot(n::SetStrategy) =
	"""
		$(getid(n)) [shape=hexagon, style=filled, fillcolor=orange, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::SetActiveDie) =
	"""
		$(getid(n)) [shape=box, style=filled, fillcolor=pink, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next)) [label="Die Available"];
		$(getid(n)) -> $(getid(n.no_die)) [label="No Matching Die"];

	"""

node2dot(n::UseActiveDie) =
	"""
		$(getid(n)) [shape=hexagon, style=filled, fillcolor=pink, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::GetAvailableDice) =
	"""
		$(getid(n)) [shape=ellipse, style=filled, fillcolor=pink, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::SetRingAvailable) =
	"""
		$(getid(n)) [shape=ellipse, style=filled, fillcolor=pink, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""

node2dot(n::SetMoDTAvailable) =
	"""
		$(getid(n)) [shape=ellipse, style=filled, fillcolor=pink, label="$(escape_string(getmsg(n)))"];
		$(getid(n)) -> $(getid(n.next));

	"""
