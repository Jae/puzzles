require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))
require File.join(File.dirname(__FILE__), %w(.. lib simulated_annealing))

class BandwidthReduction
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    progress.size == input.size
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= []
    
    (input.keys - progress).map do |candidate|
      progress + [candidate]
    end
  end
  
  def self.reduce(input, &cost_function)
    new.backtrack(input).min_by do |arrangement|
      input.map do |from,neighbours|
        neighbours.map {|to| (arrangement.index(from) - arrangement.index(to)).abs}
      end.flatten.reduce(&:+)/2
    end
  end
end

class BandwidthReductionBySimulatedAnnealing
  include SimulatedAnnealing
  
  def cost_of(input, solution)
    input.map do |from,neighbours|
      neighbours.map {|to| (solution.index(from) - solution.index(to)).abs}
    end.flatten.reduce(&:+)/2
  end
  
  def make_progress(input, solution=nil)
    unless solution
      input.keys.shuffle
    else
      solution.shuffle
    end
  end
  
  def self.reduce(input, expected_cost)
    new.simulate(input, expected_cost)
  end
end

class TestBandwidthReduction < Test::Unit::TestCase
  def input
    {1=>[8], 2=>[7, 8], 3=>[6, 7], 4=>[5, 6], 5=>[4], 6=>[4], 7=>[2, 3], 8=>[1, 2]}
  end
  
  def bandwidth(arrangement)
    input.map {|from,neighbours| neighbours.map {|to| (arrangement.index(from) - arrangement.index(to)).abs}}.flatten.reduce(&:+)/2
  end
  
  def test_bandwidth_reduction
    arrangement = BandwidthReduction.reduce(input)
    assert_equal(6, bandwidth(arrangement))
  end
  
  def test_bandwidth_reduction_by_simulated_annealing
    arrangement = BandwidthReductionBySimulatedAnnealing.reduce(input, 6)    
    assert_equal(6, bandwidth(arrangement))
  end
end