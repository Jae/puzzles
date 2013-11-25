require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib unweighted_graph))

def remove_vertex_with_degree_of_two(graph)
  simple_graph = Hash[graph.map {|node, neighbours| [node, neighbours.clone]}]

  UnweightedGraph.depth_first_traversal(graph) do |action, args|
    if action == :process_vertex_early
      vertex = args
      simple_graph[vertex].uniq!
      if simple_graph[vertex].size == 2
        shortcircuit_vertex(simple_graph, vertex)
      end
    end
  end
  
  simple_graph
end

def shortcircuit_vertex(graph, vertex)
  neighbours = graph[vertex]
  neighbours.each_with_index do |neighbour, index|
    graph[neighbour].delete(vertex)
    graph[neighbour] << neighbours[1-index] unless graph[neighbour].include? neighbours[1-index]
  end
  graph.delete(vertex)
end

class RemoveVertexWithDegreeOfTwo < Test::Unit::TestCase
  def test_remove_vertex_with_degree_of_two
    assert_equal({
      :A=>[:C, :D, :E],
      :C=>[:A, :D, :E],
      :D=>[:A, :C, :E],
      :E=>[:A, :D, :C]
    }, remove_vertex_with_degree_of_two({
      :A=>[:B, :C, :D, :E],
      :B=>[:A, :C],
      :C=>[:A, :B, :D, :G],
      :D=>[:A, :C, :E, :F],
      :E=>[:A, :D, :F, :G],
      :F=>[:D, :E],
      :G=>[:C, :E]
    }))
  end
end