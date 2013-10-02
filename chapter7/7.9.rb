require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))
require File.join(File.dirname(__FILE__), %w(.. lib simulated_annealing))

class MaximumClique
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    candidates(input, progress).empty? && progress.keys.all? do |x|
      (progress.keys - [x]).all? {|y| input[y].include? x}
    end
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= {}
    
    (input.keys - progress.keys).select do |candidate|
      progress.keys.all? do |x|
        input[x].include? candidate
      end
    end.map do |candidate|
      progress.merge(candidate => true)
    end
  end
  
  def self.find(input)
    solutions = new.backtrack(input)
    solutions.max_by{|solution| solution.size}.keys
  end
end

class MaximumCliqueBySimulatedAnnealing
  include SimulatedAnnealing
  
  def cost_of(input, solution)
    1.0 / solution.size
  end
  
  def make_progress(input, solution=nil)
    unless solution
      [input.keys.sample]
    else
      new_member = (input.keys - solution).sample
      oposing_members = solution.select {|existing_member| !input[existing_member].include? new_member}
      (solution - oposing_members + [[new_member], oposing_members].sample)
    end
  end
  
  def self.find(input, expected_cost)
    new.simulate(input, expected_cost)
  end
end

class TestMaximumClique < Test::Unit::TestCase
  def input
    {
      A: [:L, :M, :N, :B],
      B: [:A, :N, :C],
      C: [:B, :N, :D],
      D: [:C, :N, :E],
      E: [:D, :N, :O, :F],
      F: [:E, :O, :G],
      G: [:F, :O, :P, :H],
      H: [:G, :I, :P],
      I: [:J, :Q, :P, :H],
      J: [:K, :Q, :I],
      K: [:L, :Q, :J],
      L: [:A, :M, :Q, :K],
      M: [:L, :A, :N, :O, :P, :Q],
      N: [:A, :B, :C, :D, :E, :O, :P, :Q, :M],
      O: [:M, :N, :E, :F, :G, :P, :Q],
      P: [:Q, :M, :N, :O, :G, :H, :I],
      Q: [:K, :L, :M, :N, :O, :P, :I, :J]
    }
  end
  
  def test_maximum_clique
    solution = MaximumClique.find(input)
    assert_equal([:M, :N, :O, :P, :Q], solution)
  end
  
  def test_maximum_clique_by_simulated_annealing
    solution = MaximumCliqueBySimulatedAnnealing.find(input, 1.0/5)
    assert_equal([:M, :N, :O, :P, :Q], solution.sort)
  end
end