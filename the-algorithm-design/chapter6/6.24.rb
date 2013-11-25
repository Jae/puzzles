require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib weighted_graph))

def max_matching_in_tree(tree)
  coloured = {}
  tree.each do |node, connected|
    coloured[node] ||= 1
    connected.each {|to_be_coloured| coloured[to_be_coloured] = 3 - coloured[node]}
  end
  coloured.each do |node, colour|
    tree[colour.to_s.to_sym] ||= []
    tree[colour.to_s.to_sym] << node
    tree[node] << colour.to_s.to_sym
  end
  graph = Hash[tree.map {|node, connected| [node, Hash[connected.map{|neighbour| [neighbour,1]}]]}]
  WeightedGraph.maximum_flow(graph, :"1", :"2").last.map do |(flow, path)|
    path.slice(1..2)
  end
end

class MaximumMatchingInTree < Test::Unit::TestCase
  def test_max_matching_in_tree
    tree = {
      A: [:D],
      B: [:D, :E],
      C: [:E, :F],
      D: [:A, :B, :G],
      E: [:B, :C],
      F: [:C],
      G: [:D, :H, :I],
      H: [:G],
      I: [:G, :J],
      J: [:I]
    }
    
    assert_equal([[:A, :D], [:B, :E], [:C, :F], [:G, :H], [:J, :I]], max_matching_in_tree(tree))
  end
end