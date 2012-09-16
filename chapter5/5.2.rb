require "test/unit"

def dfs(graph, node, visited=[], processed=[])
  visited << node
  graph[node].sort.each do |neighbour|
    raise "cycle detected #{node} -> #{neighbour}, #{visited.inspect}" if visited.include? neighbour and !processed.include? neighbour
    dfs(graph, neighbour, visited, processed) unless visited.include? neighbour
  end
  processed << node
end

def topological_sort(graph)
  visited = []
  processed = []
  graph.keys.each do |root|
    dfs(graph, root, visited, processed) unless visited.include? root
  end
  processed.reverse
end

class TestTopologicalSort < Test::Unit::TestCase
  def test_topological_sort_failed_due_to_cycle_in_graph
    assert_raise(RuntimeError) do
      topological_sort({
        A:[:B, :D], 
        B:[:C, :D, :E], 
        C:[:F], 
        D:[:E, :G],
        E:[:C, :F, :G],
        F:[:H],
        G:[:I, :F],
        H:[:G, :J],
        I:[:J],
        J:[]
      })
    end
  end
  
  def test_topological_sort
    assert_equal([:A, :B, :D, :E, :C, :F, :H, :G, :I, :J], topological_sort({
      A:[:B, :D], 
      B:[:C, :D, :E], 
      C:[:F], 
      D:[:E, :G],
      E:[:C, :F, :G],
      F:[:H],
      G:[:I],
      H:[:G, :J],
      I:[:J],
      J:[]
    }))
  end
end