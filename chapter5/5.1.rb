require "test/unit"

def bfs(graph, start)
  visit = []
  progress = [start]
  until progress.empty? do
    node = progress.shift
    visit << node unless visit.include? node
    graph[node].sort.each do |neighbour|
      progress << neighbour unless visit.include? neighbour
    end
  end
  visit
end

def dfs(graph, node, visit=[])
  visit << node
  graph[node].sort.each do |neighbour|
    dfs(graph, neighbour, visit) unless visit.include? neighbour
  end
  visit
end

class TestNodeVisitOrder < Test::Unit::TestCase
  def test_bfs
    assert_equal([:A, :B, :D, :I, :C, :E, :G, :J, :F, :H], bfs({
      A:[:B, :D, :I], 
      B:[:A, :C, :D, :I], 
      C:[:B, :F, :I], 
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
    assert_equal([:A, :B, :C, :F, :E, :D, :G, :H, :J, :I], dfs({
      A:[:B, :D, :I], 
      B:[:A, :C, :D, :I], 
      C:[:B, :F, :I], 
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