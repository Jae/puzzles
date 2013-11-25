require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib unweighted_graph))

def minimum_feedback_unweighted_edge_set(graph)
  cycles = []
  parents = {}
  UnweightedGraph.depth_first_traversal(graph, graph.keys.first) do |operation, args|
    if operation == :process_edge
      type, from, to = args
      if type == :tree_edge
        parents[to] = from
      elsif type == :back_edge
        cycle = [from, to]
        cycle.unshift(from) while (from = parents[from]) && from != to
        cycle.unshift(to)
        cycles << cycle if cycle.size > 3
      end
    end
  end
  
  cycle_segments = {}
  cycles.each_with_index do |cycle, i|
    cycle.each_cons(2) do |segment|
      cycle_segments[segment] ||= []
      cycle_segments[segment] << i
    end
  end
  
  feedback_edge_set = []
  remaining_cycles = (0...cycles.size).to_a
  until remaining_cycles.empty? do
    most_used_cycle_segment = cycle_segments.sort_by {|cycle_segment, in_cycles| -(remaining_cycles & in_cycles).size }.first
    feedback_edge_set << most_used_cycle_segment[0]
    remaining_cycles -= most_used_cycle_segment[1]
  end
  
  feedback_edge_set
end

class MinimumFeedbackEdgeSet < Test::Unit::TestCase
  def test_minimum_feedback_unweighted_edge_set
    assert_equal([[:C, :D], [:A, :B]], minimum_feedback_unweighted_edge_set({
      A: [:B],
      B: [:A, :C, :D],
      C: [:A, :B, :D, :E],
      D: [:B, :C, :E],
      E: [:C, :D]
    }))
  end
end