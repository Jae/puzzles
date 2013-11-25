require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def find_knapsack(target, coins)
  progress = DynamicProgress.new(coins.size, target) do |current_goal, operation|
    operation[:knapsack].reduce(&:+) == target && operation || current_goal
  end
  
  progress.each do |i, j| #progress[i,j] = knapsack for the amount j using first i coins
    if j == 0
      {:knapsack => []}
    else
      [
        progress[i-1, j] && {:knapsack => progress[i-1, j][:knapsack]} || nil,
        progress[i-1, j-coins[i-1]] && {:knapsack => progress[i-1, j-coins[i-1]][:knapsack] + [coins[i-1]]} || nil
      ].compact.min_by {|e| e[:knapsack].size}
    end
  end
  
  progress.goal && progress.goal[:knapsack].sort || []
end

class TestKnapsackProblem < Test::Unit::TestCase
  def test_knapsack
    assert_equal([1, 5, 6], find_knapsack(12, [2, 5, 6, 3, 8, 1]))
    assert_equal([1, 2, 9, 10], find_knapsack(22, [10, 5, 2, 9, 1]))
    assert_equal([], find_knapsack(23, [1, 2, 5, 9, 10]))
    assert_equal([5, 10, 15, 16, 30, 45], find_knapsack(121, [1, 2, 30, 9, 10, 15, 16, 5, 45]))
  end
end