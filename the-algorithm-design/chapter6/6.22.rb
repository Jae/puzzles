require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib weighted_graph))

def shortest_path(shortest_path_tree, from, to)
  unless to == from
    path = [to]
    while (shortest_path_tree[to][1] != from) do
      to = shortest_path_tree[to][1]
      path << to
    end
    path << from
    path.reverse
  else
    [from]
  end
end

def shortest_path_of_length(length, graph, from, to, shortest_path_tree=WeightedGraph.shortest_path_tree(graph, from))
  if length <= 0
    nil
  else
    path = shortest_path(shortest_path_tree, from, to)
    if path.size - 1 == length
      [path, shortest_path_tree[to][0]]
    else
      graph[to].inject([]) do |memo, (neighbour, distance)|
        path_to_neighbour = shortest_path_of_length(length-1, graph, from, neighbour, shortest_path_tree)
        memo << [path_to_neighbour[0] + [to], path_to_neighbour[1] + distance] if path_to_neighbour
        memo
      end.min_by {|path, distance| distance}
    end
  end
end

def graph
  {
    A: {B:6, D:4, I:9},
    B: {A:6, C:3, D:3, E:1},
    C: {B:3, E:2, F:2},
    D: {A:4, B:3, E:4, G:6},
    E: {B:1, C:2, D:4, F:8, G:6, H:7},
    F: {C:2, E:8, H:11},
    G: {D:6, E:6, H:3, I:2, J:2},
    H: {E:7, F:11, G:3, J:4},
    I: {A:9, G:2, J:1},
    J: {G:2, H:4, I:1}
  }
end

class KEdgeShortestPath < Test::Unit::TestCase
  def test_k_edge_shortest_path
    assert_equal([[:A, :D, :B, :E, :H], 15], shortest_path_of_length(4, graph, :A, :H))
    assert_equal([[:A, :B, :E, :B, :E], 9], shortest_path_of_length(4, graph, :A, :E))
  end
end