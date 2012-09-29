require "test/unit"

def remove_vertex_with_degree_of_two(graph, node=graph.keys.first, visited=[])
  if graph[node].size == 2
    u = graph[node].first
    w = graph[node].last
    graph[u].delete(node)
    graph[u] << w unless graph[u].include? w
    graph[w].delete(node)
    graph[w] << u unless graph[w].include? u
    graph.delete(node)
    
    remove_vertex_with_degree_of_two(graph, u, visited)
  else
    visited << node
    graph[node].each do |next_node|
      remove_vertex_with_degree_of_two(graph, next_node, visited) unless visited.include? next_node
    end
  end
  graph
end

class TestRemoveVertexWithDegreeOfTwo < Test::Unit::TestCase
  def test_remove_vertex_with_degree_of_two
    assert_equal({
      :A=>[:C, :D, :E],
      :C=>[:A, :D, :E],
      :D=>[:A, :C, :E],
      :E=>[:A, :D, :C]
    }, remove_vertex_with_degree_of_two({
      A:[:B, :C, :D, :E],
      B:[:A, :C],
      C:[:A, :B, :D, :G],
      D:[:A, :C, :E, :F],
      E:[:A, :D, :F, :G],
      F:[:D, :E],
      G:[:C, :E]
    }))
  end
end