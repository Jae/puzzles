require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib weighted_graph))

def new_minimum_spanning_tree_from_additional_edge(tree, new_edge)
  from, to, distance = new_edge
  unless tree[from].include? to
    path = WeightedGraph.unweighted_path(tree, from, to)
    max_segment = path.each_cons(2).map {|first, second| [first, second, tree[first][second]]}.max_by {|(first, second, distance)| distance}
    if max_segment[2] > distance
      tree[from][to] = distance
      tree[to][from] = distance
      tree[max_segment[0]].delete(max_segment[1])
      tree[max_segment[1]].delete(max_segment[0])
    end
    tree
  else
    tree
  end
end

class NewMinimumSpanningTreeFromAdditionalEdge < Test::Unit::TestCase
  def test_new_min_spanning_Tree_from_additional_edge
    assert_equal({
     A: {D:4},
     B: {E:1, D:3, H:4},
     C: {E:2, F:2},
     D: {B:3, A:4},
     E: {B:1, C:2},
     F: {C:2},
     G: {I:2, H:3},
     H: {B:4, G:3},
     I: {J:1, G:2},
     J: {I:1}
    }, new_minimum_spanning_tree_from_additional_edge({
     A: {D:4},
     B: {E:1, D:3},
     C: {E:2, F:2},
     D: {B:3, A:4, G:6},
     E: {B:1, C:2},
     F: {C:2},
     G: {I:2, H:3, D:6},
     H: {G:3},
     I: {J:1, G:2},
     J: {I:1}
    }, [:B, :H, 4]))
  end
end