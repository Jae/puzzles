require "test/unit"

def bfs(graph, start)
  visited = []
  to_visit = [start]
  until to_visit.empty? do
    node = to_visit.shift
    visited << node unless visited.include? node
    graph[node].sort.each do |neighbour|
      to_visit << neighbour unless visited.include? neighbour
    end
  end
  visited
end

def dfs(graph, node, visited=[])
  visited << node
  graph[node].sort.each do |neighbour|
    dfs(graph, neighbour, visited) unless visited.include? neighbour
  end
  visited
end

class NodeVisitOrder < Test::Unit::TestCase
  def test_bfs
    assert_equal([:A, :B, :D, :I, :C, :E, :G, :J, :F, :H], bfs({
      A:[:B, :D, :I], 
      B:[:A, :C, :D, :I], 
      C:[:B, :F, :E], 
      D:[:A, :B, :E, :G],
      E:[:B, :C, :D, :F, :G, :H],
      F:[:C, :E, :H],
      G:[:D, :E, :H, :I, :J],
      H:[:E, :F, :G, :J],
      I:[:A, :G, :J],
      J:[:G, :H, :I]
    }, :A))
  end
  
  def test_dfs
    assert_equal([:A, :B, :C, :E, :D, :G, :H, :F, :J, :I], dfs({
      A:[:B, :D, :I], 
      B:[:A, :C, :D, :I], 
      C:[:B, :F, :E], 
      D:[:A, :B, :E, :G],
      E:[:B, :C, :D, :F, :G, :H],
      F:[:C, :E, :H],
      G:[:D, :E, :H, :I, :J],
      H:[:E, :F, :G, :J],
      I:[:A, :G, :J],
      J:[:G, :H, :I]
    }, :A))
  end
end