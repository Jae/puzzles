require "test/unit"
require "set"

def edges(graph)
  graph.inject(Set.new) do |edges, (vertex, next_vertices)|
    next_vertices.each {|next_vertex| edges << [vertex, next_vertex].sort}
    edges
  end.to_a
end

def colour_edges(graph, progress=[], coloured=[])
  if coloured.empty? or progress.size <= coloured.first.size
    if progress.flatten(1).size < edges(graph).size
      next_edge = (edges(graph) - progress.flatten(1)).first
      colour_groups = progress.reject {|colour_group| colour_group.any? {|edge| edge.include? next_edge.first or edge.include? next_edge.last}}
      unless colour_groups.empty?
        colour_groups.each do |colour_group|
          colour_edges(graph, (progress - [colour_group]) + [colour_group + [next_edge]], coloured)
        end
      else
        colour_edges(graph, progress + [[next_edge]], coloured)
      end
    else
      coloured.delete_if {|previous_progress| previous_progress.size > progress.size}
      coloured << progress.sort_by {|colour_group| colour_group.sort!; colour_group.first}
    end
  end
  coloured
end

class TestEdgeColouring < Test::Unit::TestCase
  def test_colour_edges
    assert_block("should colour edges") do
      coloured = colour_edges({
        A:[:B, :C, :D], 
        B:[:A, :E, :F], 
        C:[:A, :G, :H], 
        D:[:A, :I, :J],
        E:[:B, :F, :K],
        F:[:B, :E, :K],
        G:[:C, :H, :L],
        H:[:C, :G, :L],
        I:[:D, :J, :M],
        J:[:D, :I, :M],
        K:[:E, :F, :N],
        L:[:G, :H, :N],
        M:[:I, :J, :N],
        N:[:K, :L, :M]
      })

      coloured.include? [
        [[:A,:B], [:C,:G], [:D,:I], [:E,:F], [:H,:L], [:J,:M], [:K,:N]],
        [[:A,:C], [:B,:E], [:D,:J], [:F,:K], [:G,:H], [:I,:M], [:L,:N]],
        [[:A,:D], [:B,:F], [:C,:H], [:E,:K], [:G,:L], [:I,:J], [:M,:N]]
      ]
    end
  end
end