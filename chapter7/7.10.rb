require "test/unit"

def colour_vertices(graph, progress=[], coloured=[], number_of_iterations=0)
  number_of_iterations += 1
  if coloured.empty? or progress.size <= coloured.first.size
    if progress.flatten.size < graph.keys.size
      next_vertex = (graph.keys - progress.flatten).first
      colour_groups = progress.reject {|colour_group| graph[next_vertex].any? {|neighbour| colour_group.include? neighbour}}
      unless colour_groups.empty?
        colour_groups.each do |colour_group|
          number_of_iterations = colour_vertices(graph, (progress - [colour_group]) + [colour_group + [next_vertex]], coloured, number_of_iterations).first
        end
      else
        number_of_iterations = colour_vertices(graph, progress + [[next_vertex]], coloured, number_of_iterations).first
      end
    else
      coloured.delete_if {|previous_progress| previous_progress.size > progress.size}
      coloured << progress.sort_by {|colour_group| colour_group.sort!; colour_group.first}
    end
  end
  [number_of_iterations, coloured]
end

def colour_vertices_via_simulated_annealing(graph, expected_cost)
  temp = 1
  coloured = graph.keys.map {|vertex| [vertex]}
  number_of_iterations = 0
  begin
    10.times do |_|
      number_of_iterations += 1
      random_vertex = coloured.sample.sample
      origin_colour_group = coloured.find {|colour_group| colour_group.include? random_vertex}
      target_colour_group = (coloured - [origin_colour_group]).reject {|colour_group| colour_group.any? {|vertex| graph[random_vertex].include? vertex}}.sample || []
      
      progress = (
        (coloured - [target_colour_group] - [origin_colour_group]) + 
        [target_colour_group + [random_vertex]] + 
        [origin_colour_group - [random_vertex]]
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
      
      p coloured
      coloured.last.include? [[:A, :D, :G, :J, :M], [:B, :E, :H, :K, :N], [:C, :F, :I, :L]]
    end
  end
  
  def test_colour_vertices_via_simulated_annealing
    assert_block("should colour vertices") do
      coloured = colour_vertices_via_simulated_annealing({
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
      }, 3)
      
      p coloured
      coloured.first <= 202
    end
  end
end