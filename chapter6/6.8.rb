require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib weighted_graph))

def changes_in_non_mst_edge_to_invalidate_mst(graph, mst)
  changes = {}
  graph.each do |from, neighbours|
    neighbours.each do |to, distance|
      if !mst[from].include?(to) && !changes.include?([from, to]) && !changes.include?([to,from])
        path = WeightedGraph.unweighted_path(mst, from, to)
        max_segment = path.each_cons(2).map {|from, to| [from, to, graph[from][to]]}.max_by {|(from, to, distance)| distance}
        changes[[from, to]] = graph[from][to] - max_segment[2] + 1
      end
    end
  end
  Hash[changes.sort_by {|edge, distance| distance}]
end

class MinChangeInNonMSTEdgeToInvalidateMST < Test::Unit::TestCase
  def test_changes_in_non_mst_edge_to_invalidate_mst
    graph = {
      A: {B:6, D:4, I:9},
      B: {A:6, C:3, D:3, E:1},
      C: {B:3, E:2, F:2},
      D: {A:4, B:3, E:4, G:6},
      E: {B:1, C:2, D:4, F:8, G:7, H:7},
      F: {C:2, E:8, H:11},
      G: {D:6, E:7, H:3, I:2, J:3},
      H: {E:7, F:11, G:3, J:4},
      I: {A:9, G:2, J:1},
      J: {G:3, H:4, I:1}
    }
    
    mst = {
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
    }
    
    assert_equal({
      [:H, :J]=>2,
      [:G, :J]=>2,
      [:B, :C]=>2,
      [:D, :E]=>2,
      [:E, :H]=>2,
      [:E, :G]=>2,
      [:A, :B]=>3,
      [:A, :I]=>4,
      [:F, :H]=>6,
      [:E, :F]=>7}, changes_in_non_mst_edge_to_invalidate_mst(graph, mst))
  end
end