require "test/unit"

def shortest_paths(graph, from, to)
  visited = [from]
  shortest_paths = [[from]]
  
  until shortest_paths.empty? || shortest_paths.any? {|path| path.last == to}
    shortest_paths = shortest_paths.map do |path|
      new_paths = graph[path.last].reject {|next_node| visited.include? next_node}.map do |next_node|
        path + [next_node]
      end
      new_paths unless new_paths.empty?
    end.compact.flatten(1)
    shortest_paths.each {|path| visited << path.last unless visited.include? path.last}
  end
  
  shortest_paths.select {|path| path.last == to}
end

class TestShortestPaths < Test::Unit::TestCase
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