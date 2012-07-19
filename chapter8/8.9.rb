require "test/unit"

def knapsack(target, numbers)
end

class TestKnapsackProblem < Test::Unit::TestCase
  def test_knapsack
    assert_equal([], knapsack(22, [1,2,5,9,10]))
    assert_equal([], knapsack(23, [1,2,5,9,10]))
  end
end