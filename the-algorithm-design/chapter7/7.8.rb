require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))
require File.join(File.dirname(__FILE__), %w(.. lib simulated_annealing))

class CNF
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    (input.map {|condition| condition.keys}.flatten.uniq - progress.keys).empty? && input.all? do |condition|
      condition.any? {|predicate| progress[predicate[0]] == predicate[1]}
    end
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= {}
    (input.map {|condition| condition.keys}.flatten.uniq - progress.keys).map do |variable|
      [{variable => true}, {variable => false}]
    end.flatten(1).map do |candidate|
      progress.merge(candidate)
    end
  end
  
  def self.satisfy(input)
    new.backtrack(input).map {|solution| Hash[solution]}
  end
end

class CNFBySimulatedAnnealing
  include SimulatedAnnealing
  
  def cost_of(input, solution)
    input.select do |condition|
      condition.all? {|predicate| solution[predicate[0]] != predicate[1]}
    end.size
  end
  
  def make_progress(input, solution=nil)
    unless solution
      input.map {|predicate| predicate.keys}.flatten.uniq.inject({}) do |memo, variable|
        memo.merge(variable => input.sample[variable])
      end
    else
      variable = solution.keys.sample
      solution.merge(variable => !solution[variable])
    end
  end
  
  def self.satisfy(input, expected_cost)
    new.simulate(input, expected_cost)
  end
end

class TestCNFSatisfaction < Test::Unit::TestCase
  def input
    [{x1: true, x2: true, x3: false}, {x1: false, x2: false, x3: true}, {x1: false, x2: false, x3: false}, {x1: false, x2: true, x3: true}]
  end
  
  def test_cnf_satisfaction
    solution = CNF.satisfy(input)
    assert(solution.include?({x1: true, x2: false, x3: true}))
  end
  
  def test_cnf_satisfaction_by_simulated_annealing
    solution = CNFBySimulatedAnnealing.satisfy(input, 0)
    assert(input.all? {|condition| condition.any? {|predicate| solution[predicate[0]] == predicate[1]}})
  end
end