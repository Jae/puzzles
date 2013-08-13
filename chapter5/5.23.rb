require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. graph_traversal unweighted_graph))

def arrange_children_in_line(graph, root=:G)
  children_in_line = []
  until children_in_line.size == graph.keys.size
    children = []
    UnweightedGraph.depth_first_traversal(graph, (graph.keys - children_in_line).first, children_in_line.dup) do |action, args|
      if action == :process_edge
        edge_type, edge_from, edge_to = *args
        raise "cycle detected!" if edge_type == :back_edge && children.include?(edge_to)
      elsif action == :process_vertex
        vertex = args
        children << vertex
      end
    end
    children_in_line += children
  end
  children_in_line.reverse
end

def arrange_children_in_rows(graph)
  arrange_children_in_line(graph).inject([]) do |in_rows, child|
    row = in_rows.reverse.take_while {|row| row.all? {|child_in_row| !graph[child_in_row].include? child}}.last
    if row
      (row << child).sort!
    else
      in_rows << [child]
    end
    in_rows
  end
end

class ArrangeChildren < Test::Unit::TestCase
  def test_arrange_children_in_straight_line
    assert_equal([:G, :A, :B, :C, :F, :E, :D], arrange_children_in_line({
      A:[:B, :C],
      B:[:C, :D],
      C:[:E, :F],
      D:[],
      E:[:D],
      F:[:E],
      G:[:A, :F]
    }))
  end
  
  def test_arrange_children_in_rows
    assert_equal([[:A, :D], [:B, :E], [:C]], arrange_children_in_rows({
      A:[:B],
      B:[:C],
      C:[],
      D:[:C, :E],
      E:[]
    }))
  end
end