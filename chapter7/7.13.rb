require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))
require File.join(File.dirname(__FILE__), %w(.. lib simulated_annealing))

class MinimumSetCover
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    input.values.flatten.uniq.sort == progress.map {|i,included| included && input[i] || []}.flatten.uniq.sort
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= {}
    
    (input.keys - progress.keys).map do |candidate|
      [progress.merge(candidate => true), progress.merge(candidate => false)]
    end.flatten(1)
  end
  
  def self.find(input)
    solutions = new.backtrack(Hash[(0...input.size).to_a.zip(input)])
    solutions.min_by do |solution| 
      solution.map {|set, included| included && 1 || 0}.reduce(&:+)
    end.map do |set, included|
      input[set] if included
    end.compact
  end
end

class MinimumSetCoverBySimulatedAnnealing
  include SimulatedAnnealing
  
  def cost_of(input, solution)
    solution.size
  end
  
  def make_progress(input, solution=nil)
    left_over = input
    progress = []
    until progress.flatten.uniq.sort == input.flatten.uniq.sort
      selected = left_over.sample
      left_over -= [selected]
      progress += [selected]
    end
    progress
  end
  
  def self.find(input, expected_cost)
    new.simulate(input, expected_cost)
  end
end

class TestMinimumSetCover < Test::Unit::TestCase
  def input
    [
      [:A, :D],
      [:B, :E],
      [:C, :F],
      [:D, :E, :G, :H],
      [:F, :K],
      [:G, :H, :I, :J, :K, :L],
      [:A, :B, :C, :D, :F, :G, :I]
    ]
  end
  
  def test_minimum_set_cover
    set_cover = MinimumSetCover.find(input)
    
    assert_equal(3, set_cover.size)
  end
  
  def test_minimum_set_cover_by_simulated_annealing
    set_cover = MinimumSetCoverBySimulatedAnnealing.find(input, 3)
    
    assert_equal(3, set_cover.size)
  end
end