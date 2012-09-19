require "test/unit"

def square_adjacency_list(graph)
  graph.map.each_with_index do |neighbours, vertex|
    neighbours.map do |neighbour|
      graph[neighbour]
    end.flatten.uniq.sort - neighbours - [vertex]
  end
end

def square_adjacency_matrix(graph)
  graph.map.each_with_index do |neighbours, vertex|
    neighbours = neighbours.map.each_with_index do |edge, neighbour|
      neighbour if edge == 1
    end.compact
    
    next_neighbours = neighbours.map do |neighbour|
      graph[neighbour].map.each_with_index do |edge, neighbour|
        neighbour if edge == 1
      end.compact
    end.flatten.uniq.sort - neighbours - [vertex]
    
    (0...graph.size).map do |vertex|
      next_neighbours.include?(vertex) ? 1 : 0
    end
  end
end

class TestSquaredGraph < Test::Unit::TestCase
  def test_square_graph
    assert_equal([
      [2, 3], 
      [3], 
      [0, 4, 5], 
      [0, 1], 
      [2, 5], 
      [2, 4]
    ], square_adjacency_list([
      [1, 4],
      [0, 2, 4],
      [1, 3],
      [2, 4, 5],
      [0, 1, 3],
      [3]
    ]))
  end
  
  def test_square_adjacency_matrix
    assert_equal([
      [0, 0, 1, 1, 0, 0],
      [0, 0, 0, 1, 0, 0],
      [1, 0, 0, 0, 1, 1],
      [1, 1, 0, 0, 0, 0],
      [0, 0, 1, 0, 0, 1],
      [0, 0, 1, 0, 1, 0]
    ], square_adjacency_matrix([
      [0, 1, 0, 0, 1, 0],
      [1, 0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0, 0],
      [0, 0, 1, 0, 1, 1],
      [1, 1, 0, 1, 0, 0],
      [0, 0, 0, 1, 0, 0]
    ]))
  end
end