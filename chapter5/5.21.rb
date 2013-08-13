require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. graph_traversal unweighted_graph))

def shortest_paths(graph, from, to)
  shortest_paths = [[from]]
  UnweightedGraph.breadth_first_traversal(graph, from) do |action, args|
    if action == :process_edge
      edge_type, edge_from, edge_to = *args
      existing_path = shortest_paths.find {|path| path.last == edge_to}
      shortest_paths.select do |path|
        if existing_path
          path.last == edge_from && path.size == existing_path.size - 1
        else
          path.last == edge_from
        end
      end.each do |paths_to_be_extended|
        shortest_paths << paths_to_be_extended + [edge_to]
      end
    end
  end
  shortest_paths.select {|path| path.last == to}
end

class ShortestPaths < Test::Unit::TestCase
  def test_shortest_paths
    assert_equal([
      [:A, :B, :F],
      [:A, :D, :F]
    ], shortest_paths({
      A:[:B, :C, :D, :G],
      B:[:A, :C, :E, :F],
      C:[:A, :B, :D],
      D:[:A, :C, :F],
      E:[:B],
      F:[:B, :D],
      G:[:A, :H],
      H:[:G]
    }, :A, :F))
  end
end