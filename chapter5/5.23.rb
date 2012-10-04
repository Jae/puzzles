require "test/unit"

def depth_first_traversal(graph, root, visited=[], processed=[])
  visited << root
  graph[root].each do |neighbour|
    depth_first_traversal(graph, neighbour, visited, processed) unless visited.include? neighbour
  end
  processed << root
end

def arrange_children_in_line(graph)
  children_in_line = depth_first_traversal(graph, graph.keys.first)
  until children_in_line.size == graph.keys.size
    children_in_line += depth_first_traversal(graph, (graph.keys - children_in_line).first, children_in_line.dup)
  end
   children_in_line.reverse
end

def arrange_children_in_rows(graph)
  arrange_children_in_line(graph).inject([]) do |in_rows, child|
    row = in_rows.reverse.take_while {|row| row.all? {|child_in_row| !graph[child_in_row].include? child}}.last
    if row
      row << child
      row.sort!
    else
      in_rows << [child]
    end
    in_rows
  end
end

class TestArrangeChildren < Test::Unit::TestCase
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