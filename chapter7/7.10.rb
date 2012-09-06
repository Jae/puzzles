require "test/unit"

def colour_vertices(graph, progress=[], coloured=[], count=0)
  if coloured.empty? or progress.size <= coloured.first.size
    if progress.flatten.size < graph.keys.size
      next_vertex = (graph.keys - progress.flatten).first
      colour_groups = progress.reject {|colour_group| graph[next_vertex].any? {|neighbour| colour_group.include? neighbour}}
      unless colour_groups.empty?
        colour_groups.each do |colour_group|
          colour_vertices(graph, (progress - [colour_group]) + [colour_group + [next_vertex]], coloured)
        end
      else
        colour_vertices(graph, progress + [[next_vertex]], coloured)
      end
    else
      coloured.delete_if {|previous_progress| previous_progress.size > progress.size}
      coloured << progress.sort_by {|colour_group| colour_group.sort!; colour_group.first}
    end
  end
  coloured
end

class TestVertexColouring < Test::Unit::TestCase
  def test_colour_vertices
    assert_block("should colour vertices") do
      coloured = colour_vertices({
        A:[:B, :C], 
        B:[:A, :C], 
        C:[:A, :B, :D, :E], 
        D:[:C, :E, :F],
        E:[:C, :D, :F],
        F:[:D, :E, :G, :H],
        G:[:F, :I],
        H:[:F, :I],
        I:[:G, :H, :J, :K],
        J:[:I, :K, :L],
        K:[:I, :J, :L],
        L:[:J, :K, :M, :N],
        M:[:L, :N],
        N:[:L, :M]
      })
      coloured.include? [[:A, :D, :G, :J, :M], [:B, :E, :H, :K, :N], [:C, :F, :I, :L]]
    end
  end
end