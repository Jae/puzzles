require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

class Array
  def subtract_once(b)
    h = b.inject({}) {|memo, v|
      memo[v] ||= 0; memo[v] += 1; memo
    }
    reject { |e| h.include?(e) && (h[e] -= 1) >= 0 }
  end
end

class Multiset
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    progress.size == input.size
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= []
    input.subtract_once(progress).uniq.map do |candidate|
      progress + [candidate]
    end
  end
  
  def self.permutate(input)
    new.backtrack(input)
  end
end

class TestPermutation < Test::Unit::TestCase
  def test_permutation_of_multiset
    assert_equal([[1,1,2,2],[1,2,1,2],[1,2,2,1],[2,1,1,2],[2,1,2,1],[2,2,1,1]], Multiset.permutate([1,1,2,2]))
  end
end