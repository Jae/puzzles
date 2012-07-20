require "test/unit"

def find_knapsack(amount, coins)
  coins.select {|coin| coin <= amount}.each do |coin|
    if amount - coin == 0
      return [coin]
    else
      smaller_knapsack = find_knapsack(amount-coin, coins-[coin])
      unless smaller_knapsack.empty?
        return [coin] + smaller_knapsack
      end
    end
  end
  return []
end

class TestKnapsackProblem < Test::Unit::TestCase
  def test_knapsack
    assert_equal([1, 2, 9, 10], find_knapsack(22, [1,2,5,9,10]))
    assert_equal([], find_knapsack(23, [1,2,5,9,10]))
  end
end