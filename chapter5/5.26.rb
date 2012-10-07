require "test/unit"

def strongly_connected_vertices_from(graph, vertex, visited, stack=[], oldest_node_connected_to={})
  visited << vertex
  stack.push vertex
  oldest_node_connected_to[vertex] = vertex
  
  strongly_connected_vertices = []
  graph[vertex].each do |neighbour|
    unless visited.include? neighbour
      strongly_connected_vertices += strongly_connected_vertices_from(graph, neighbour, visited, stack, oldest_node_connected_to)
    end
    
    if stack.include? neighbour
      oldest_node_connected_to[vertex] = visited.find {|node| node == oldest_node_connected_to[vertex] || node == oldest_node_connected_to[neighbour]}
    end
  end
  
  if oldest_node_connected_to[vertex] == vertex
    vertices = []
    begin
      vertices << (node = stack.pop)
    end until node == vertex
    strongly_connected_vertices << vertices.sort
  end
  
  strongly_connected_vertices
end

def strongly_connected_components(graph)
  visited = []
  graph.keys.map do |vertex|
    strongly_connected_vertices_from(graph, vertex, visited) unless visited.include? vertex
  end.compact.flatten(1).sort
end

def detect_mother_vertex(graph)
  strongly_connected_components = strongly_connected_components(graph)
  strongly_connected_components.select do |strongly_connected_vertices|
    strongly_connected_vertices.all? do |vertex|
      (strongly_connected_components - [strongly_connected_vertices]).flatten.all? {|neighbour| !graph[neighbour].include? vertex}
    end
  end.size < 2
end

class TestArrangeChildren < Test::Unit::TestCase
  def test_strongly_connected_components
    assert_equal([
      [:A, :B, :E],
      [:C, :D, :H],
      [:F, :G]
    ], strongly_connected_components({
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
  
  def test_mother_vertex_detection
    assert(detect_mother_vertex({
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