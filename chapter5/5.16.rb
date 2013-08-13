require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. graph_traversal unweighted_graph))

def max_independent_set(graph)
  tree = {}
  set = []
  UnweightedGraph.depth_first_traversal(graph) do |action, args|
    if action == :process_edge
      type, from, to = *args
      tree[from] ||= []
      if type == :tree_edge
        tree[from] << to
      end
    elsif action == :process_vertex
      vertex = args
      if tree[vertex].size > 0
        candidates = tree[vertex].reject {|child| tree[child].any? {|grand_child| set.include? grand_child}}
        if candidates.size >= 1
          candidates.each {|candidate| set << candidate unless set.include? candidate }
        else
          set << vertex unless set.include? vertex
        end
      end
    end
  end
  set.sort
end

def max_independent_set_by_degree_of_node(graph)
  tree = {}
  set = []
  UnweightedGraph.depth_first_traversal(graph) do |action, args|
    if action == :process_edge
      type, from, to = *args
      tree[from] ||= []
      if type == :tree_edge
        tree[from] << to
      end
    elsif action == :process_vertex
      vertex = args
      if tree[vertex].size > 0
        candidates = tree[vertex].reject {|child| tree[child].any? {|grand_child| set.include? grand_child}}
        if (candidates.map{|candidate| graph[candidate].size}.reduce(:+) || 0) >= graph[vertex].size
          candidates.each {|candidate| set << candidate unless set.include? candidate }
        else
          set << vertex unless set.include? vertex
        end
      end
    end
  end
  set.sort
end

class MaxIndependentSet < Test::Unit::TestCase
  def test_max_independent_set
    assert_equal([:A, :D, :F, :G, :H, :I, :K, :L, :M, :N], max_independent_set({
      A:[:B,:C],
      B:[:A,:D,:E],
      C:[:A,:I,:J,:K],
      D:[:B],
      E:[:B,:F,:G,:H],
      F:[:E],
      G:[:E],
      H:[:E],
      I:[:C],
      J:[:C,:L,:M,:N],
      K:[:C],
      L:[:J],
      M:[:J],
      N:[:J]
    }))
  end
  
  def test_max_independent_set_by_degree_of_node
    assert_equal([:A, :D, :E, :I, :J, :K], max_independent_set_by_degree_of_node({
      A:[:B,:C],
      B:[:A,:D,:E],
      C:[:A,:I,:J,:K],
      D:[:B],
      E:[:B,:F,:G,:H],
      F:[:E],
      G:[:E],
      H:[:E],
      I:[:C],
      J:[:C,:L,:M,:N],
      K:[:C],
      L:[:J],
      M:[:J],
      N:[:J]
    }))
  end
end