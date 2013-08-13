require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. graph_traversal unweighted_graph))

def max_induced_sub_graph(graph, minimum_degree)
  sub_graph = Hash[graph.map {|node, neighbours| [node, neighbours.clone]}]
  
  UnweightedGraph.depth_first_traversal(graph) do |action, args|
    if action == :process_vertex
      vertex = args
      if sub_graph[vertex].size < minimum_degree
        sub_graph[vertex].each {|neighbour| sub_graph[neighbour].delete(vertex)}
        sub_graph.delete(vertex)
      end
    end
  end
  sub_graph
end

class MaxInducedSubGraph < Test::Unit::TestCase
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