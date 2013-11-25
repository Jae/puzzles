require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib unweighted_graph))

def mother_vertex?(graph, vertex)
  reachable = []
  UnweightedGraph.depth_first_traversal(graph, vertex, reachable)
  reachable.size == graph.keys.size
end

def any_mother_vertex?(graph)
  candidates = graph.keys.dup
  until candidates.empty?
    vertex = candidates.shift
    reachable = []
    UnweightedGraph.depth_first_traversal(graph, vertex, reachable)
    return true if reachable.size == graph.keys.size
    candidates -= reachable
  end
  false
end

class MotherVertex < Test::Unit::TestCase
  def test_mother_vertex
    assert(mother_vertex?({
      A:[:B],
      B:[:C, :E, :F],
      C:[:D, :G],
      D:[:C, :H],
      E:[:A, :F],
      F:[:G],
      G:[:F],
      H:[:D, :G]
    }, :B))
  end
  
  def test_mother_vertex_detection
    assert(any_mother_vertex?({
      A:[:B],
      B:[:C, :E, :F],
      C:[:D, :G],
      D:[:C, :H],
      E:[:A, :F],
      F:[:G],
      G:[:F],
      H:[:D, :G]
    }))
  end
end