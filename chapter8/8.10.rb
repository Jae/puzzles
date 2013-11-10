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

def partition(coins)
  sum = coins.reduce(&:+)
  return [[],[]] unless sum % 2 == 0
  first_partition = find_knapsack(sum/2, coins)
  [first_partition, coins - first_partition].sort
end

class TestSetPartition < Test::Unit::TestCase
  def test_partition_set_into_two_of_equal_sum
    assert_equal([[1, 4], [2, 3]], partition([1, 2, 3, 4]))
    assert_equal([[1, 3, 10], [5, 9]], partition([1, 3, 5, 9, 10]))
  end
end