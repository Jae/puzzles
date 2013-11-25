require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

class Derangement
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    progress.size == input.size
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= []
    (input - progress).reject {|candidate| input[progress.size] == candidate}.map do |candidate|
      progress + [candidate]
    end
  end
  
  def self.derange(input)
    new.backtrack(input)
  end
end

class TestDerangement < Test::Unit::TestCase
  def test_derangement
    assert_equal([[2, 3, 1], [3, 1, 2]], Derangement.derange([1,2,3]))
    assert_equal([[2, 1, 4, 3],[2, 3, 4, 1],[2, 4, 1, 3],[3, 1, 4, 2],[3, 4, 1, 2],[3, 4, 2, 1],[4, 1, 2, 3],[4, 3, 1, 2],[4, 3, 2, 1]], Derangement.derange([1,2,3,4]))
  end
end