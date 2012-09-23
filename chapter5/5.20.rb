require "test/unit"

def max_induced_sub_graph(graph, minimum_degree, root=graph.keys.first)
  sub_graph = Hash[graph.map {|(node, neighbours)| [node, neighbours.clone]}]
  until sub_graph.all? {|(_,neighbours)| neighbours.size >= minimum_degree }
    sub_graph.select {|node| sub_graph[node].size < minimum_degree}.each do |(node, neighbours)|
      sub_graph.delete(node)
      neighbours.each {|neighbour| sub_graph[neighbour].delete(node)}
    end
  end
  sub_graph
end

class TestMaxInducedSubGraph < Test::Unit::TestCase
  def test_max_induced_sub_graph
    assert_equal({
      A:[:B, :C, :D],
      B:[:A, :C, :F],
      C:[:A, :B, :D],
      D:[:A, :C, :F],
      F:[:B, :D]
    }, max_induced_sub_graph({
      A:[:B, :C, :D, :G],
      B:[:A, :C, :E, :F],
      C:[:A, :B, :D],
      D:[:A, :C, :F],
      E:[:B],
      F:[:B, :D],
      G:[:A, :H],
      H:[:G]
    }, 2))
  end
  
  def test_max_induced_sub_graph_to_empty_when_not_possible
    assert_equal({}, max_induced_sub_graph({
      A:[:B, :C, :D, :G],
      B:[:A, :C, :E, :F],
      C:[:A, :B, :D],
      D:[:A, :C, :F],
      E:[:B],
      F:[:B, :D],
      G:[:A, :H],
      H:[:G]
    }, 3))
  end
end