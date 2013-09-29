require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

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

class TestCNFSatisfaction < Test::Unit::TestCase
  def test_cnf_satisfaction
    solution = CNF.satisfy([{x1: true, x2: true, x3: false}, {x1: false, x2: false, x3: true}, {x1: false, x2: false, x3: false}, {x1: false, x2: true, x3: true}])
    assert(solution.include?({x1: true, x2: false, x3: true}))
  end
end