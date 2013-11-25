require "test/unit"

def switch_from_adjacency_matrix_to_list_in_n_square(graph)
  graph.map do |vertices|
    adjacency_list = []
    vertices.each_with_index {|neighbour, vertex| adjacency_list << vertex if neighbour == 1}
    adjacency_list
  end
end

def switch_from_adjacency_list_to_incidence_matrix_in_n_times_m(graph)
  edges = {}
  graph.each_with_index do |neighbours, vertex|
    neighbours.each do |neighbour|
      edge = [vertex, neighbour].sort
      edges[edge] = edges.size unless edges[edge]
    end
  end
  
  edges.invert.map do |(index, edge)|
    (0...graph.size).map do |vertex|
      edge.include?(vertex) ? 1 : 0
    end
  end.transpose
end

def switch_from_incidence_matrix_to_adjacency_list_in_n_times_m(graph)
  graph.transpose.inject(Array.new(graph.size) {[]}) do |adjacency_list, edge|
    vertices = edge.map.each_with_index do |neighbour, vertex|
      vertex if neighbour == 1
    end.compact
    adjacency_list[vertices.first] << vertices.last
    adjacency_list[vertices.last] << vertices.first
    adjacency_list
  end
end

class SwitchGraphDataStructure < Test::Unit::TestCase
  def test_switch_from_adjacency_matrix_to_list
    assert_equal([[1,4],[0,2,4],[1,3],[2,4,5],[0,1,3],[3]], switch_from_adjacency_matrix_to_list_in_n_square([
      [0, 1, 0, 0, 1, 0],
      [1, 0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0, 0],
      [0, 0, 1, 0, 1, 1],
      [1, 1, 0, 1, 0, 0],
      [0, 0, 0, 1, 0, 0]
    ]))
  end
  
  def test_switch_from_adjacency_list_to_incidence_matrix
    assert_equal([
      [1, 1, 0, 0, 0, 0, 0],
      [1, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 0, 1, 0, 0],
      [0, 0, 0, 0, 1, 1, 1],
      [0, 1, 0, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 1]
    ], switch_from_adjacency_list_to_incidence_matrix_in_n_times_m([[1,4],[0,2,4],[1,3],[2,4,5],[0,1,3],[3]]))
  end
  
  def test_switch_from_incidence_matrix_to_adjacency_list
    assert_equal([[1,4],[0,2,4],[1,3],[2,4,5],[0,1,3],[3]], switch_from_incidence_matrix_to_adjacency_list_in_n_times_m([
      [1, 1, 0, 0, 0, 0, 0],
      [1, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 0, 1, 0, 0],
      [0, 0, 0, 0, 1, 1, 1],
      [0, 1, 0, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 1]
    ]))
  end
end