require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))
require File.join(File.dirname(__FILE__), %w(.. lib simulated_annealing))

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

class VertexColouringBySimulatedAnnealing
  include SimulatedAnnealing
  
  def cost_of(input, solution)
    solution.values.uniq.size
  end
  
  def make_progress(input, solution=nil)
    unless solution
      Hash[input.keys.each_with_index.map {|node, index| [node, index]}]
    else
      random_node = solution.keys.sample
      solution.merge(random_node => (solution.values.uniq - [solution[random_node]]).sample)
    end
  end
  
  def self.colour(input, expected_cost)
    new.simulate(input, expected_cost)
  end
end

class TestVertexColouring < Test::Unit::TestCase
  def input
    {
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
    }
  end
  
  def test_colour_vertices
    assert_block("should colour vertices") do
      coloured = VertexColouringByCombinatorialSearch.colour(input)
      assert_equal(3, coloured.values.uniq.size)
    end
  end
  
  def test_colour_vertices_via_simulated_annealing
    assert_block("should colour vertices") do
      coloured = VertexColouringBySimulatedAnnealing.colour(input, 3)
      assert_equal(3, coloured.values.uniq.size)
    end
  end
end