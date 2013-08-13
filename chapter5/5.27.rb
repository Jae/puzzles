require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. graph_traversal unweighted_graph))

def hamiltonian_path(graph)
  candidates = graph.keys.dup
  until candidates.empty?
    vertex = candidates.shift
    visited = []
    UnweightedGraph.depth_first_traversal(graph, vertex, visited) do |action, args|
      if action == :process_vertex
        if visited.size == graph.keys.size
          return visited
        else
          visited.delete(args)
        end
      end
    end
  end
end

class HamiltonianPath < Test::Unit::TestCase
  def test_hamiltonian_path
    assert_not_nil(hamiltonian_path({
      A:[:B, :D],
      B:[],
      C:[:A, :B],
      D:[:B, :C]
    }))
  end
end