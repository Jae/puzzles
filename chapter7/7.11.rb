require "test/unit"
require "set"

def edges(graph)
  graph.inject(Set.new) do |edges, (vertex, next_vertices)|
    next_vertices.each {|next_vertex| edges << [vertex, next_vertex].sort}
    edges
  end.to_a
end

def colour_edges(graph, progress=[], coloured=[], number_of_iterations=0)
  number_of_iterations += 1
  if coloured.empty? or progress.size <= coloured.first.size
    if progress.flatten(1).size < edges(graph).size
      next_edge = (edges(graph) - progress.flatten(1)).first
      colour_groups = progress.reject {|colour_group| colour_group.any? {|edge| edge.include? next_edge.first or edge.include? next_edge.last}}
      unless colour_groups.empty?
        colour_groups.each do |colour_group|
          number_of_iterations = colour_edges(graph, (progress - [colour_group]) + [colour_group + [next_edge]], coloured, number_of_iterations).first
        end
      else
        number_of_iterations = colour_edges(graph, progress + [[next_edge]], coloured, number_of_iterations).first
      end
    else
      coloured.delete_if {|previous_progress| previous_progress.size > progress.size}
      coloured << progress.sort_by {|colour_group| colour_group.sort!; colour_group.first}
    end
  end
  [number_of_iterations, coloured]
end

def colour_edges_via_simulated_annealing(graph, expected_cost)
  temp = 1
  coloured = edges(graph).map {|edge| [edge]}
  number_of_iterations = 0
  begin
    10.times do |_|
      number_of_iterations += 1
      random_edge = coloured.sample.sample
      origin_colour_group = coloured.find {|colour_group| colour_group.include? random_edge}
      target_colour_group = (coloured - [origin_colour_group]).reject {|colour_group| colour_group.any? {|edge| edge.include? random_edge.first or edge.include? random_edge.last}}.sample || []
      
      progress = (
        (coloured - [target_colour_group] - [origin_colour_group]) + 
        [target_colour_group + [random_edge]] + 
        [origin_colour_group - [random_edge]]
       ).reject {|colour_group| colour_group.empty?}
       
      if progress.size < coloured.size
        coloured = progress
      elsif Math.exp((coloured.size - progress.size)/temp) > rand
        coloured = progress
      end
    end
    temp *= 0.8
  end until coloured.size <= expected_cost
  [number_of_iterations, coloured]
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
      
      p coloured
      coloured.last.include? [
        [[:A,:B], [:C,:G], [:D,:I], [:E,:F], [:H,:L], [:J,:M], [:K,:N]],
        [[:A,:C], [:B,:E], [:D,:J], [:F,:K], [:G,:H], [:I,:M], [:L,:N]],
        [[:A,:D], [:B,:F], [:C,:H], [:E,:K], [:G,:L], [:I,:J], [:M,:N]]
      ]
    end
  end
  
  def test_colour_edges_via_simulated_annealing
    assert_block("should colour edges") do
      coloured = colour_edges_via_simulated_annealing({
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
      }, 3)
      
      p coloured
      coloured.first <= 128
    end
  end
end