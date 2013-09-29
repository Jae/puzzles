require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

class VertexColouringByCombinatorialSearch
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    input.size == progress.size && progress.group_by {|node, colour| colour}.map do |colour, assoc| 
      Hash[assoc].keys
    end.all? do |coloured|
      coloured.all? do |node|
        (coloured - [node]).all? {|other| !input[other].include? node}
      end
    end
  end
  
  def candidates(input, progress, solutions)
    progress ||= {}
    
    return [] if !solutions.empty? && solutions.map {|solution| solution.values.uniq.size}.min >= progress.values.uniq.size 
    
    candidates = (input.keys - progress.keys).map do |candidate|
      progress.values.uniq.map do |existing_colour|
        progress.merge(candidate => existing_colour)
      end
    end.flatten(1).select do |progress|
      progress.group_by {|node, colour| colour}.map do |colour, assoc| 
        Hash[assoc].keys
      end.all? do |coloured|
        coloured.all? do |node|
          (coloured - [node]).all? {|other| !input[other].include? node}
        end
      end
    end
    
    candidates.empty? && (input.keys - progress.keys).map do |candidate|
      progress.merge(candidate => (progress.values.uniq.max||0)+1)
    end || candidates
  end
  
  def self.colour(input)
    solutions = new.backtrack(input)
    solutions.min_by{|solution| solution.values.uniq.size}
  end
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
      coloured = VertexColouringByCombinatorialSearch.colour({
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
      
      assert_equal(3, coloured.values.uniq.size)
    end
  end
  
  def x_test_colour_vertices_via_simulated_annealing
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