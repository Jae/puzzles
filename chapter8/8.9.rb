require "test/unit"

def find_knapsack_dynamically(target, set)
  knapsack = Array.new(set.size+1) {[]} # knapsack[i][j] = [distance, with_ith?] where distance is minimum distance from jth_target and sum from subset of first ith_in_set with ith included in that sum
  (0..set.size).each do |ith_in_set|
    knapsack[ith_in_set][0] = [0, false]
  end
  (0..target).each do |jth_target|
    knapsack[0][jth_target] = [jth_target, false]
  end
  
  (1..set.size).each do |ith_in_set|
    (1..target).each do |jth_target|
      if set[ith_in_set-1] > jth_target
        knapsack[ith_in_set][jth_target] = [knapsack[ith_in_set-1][jth_target][0], false]
      else
        knapsack[ith_in_set][jth_target] = [
          [knapsack[ith_in_set-1][jth_target][0], false],
          [knapsack[ith_in_set-1][jth_target-set[ith_in_set-1]][0], true]
        ].min_by {|(distance, _)| distance}
      end
    end
  end
  
  subset = []
  (1..set.size).to_a.reverse.inject(target) do |current_target, ith_in_set|
    p [ith_in_set, current_target, knapsack[ith_in_set][current_target]]
    if knapsack[ith_in_set][current_target][1]
      subset << set[ith_in_set-1]
      current_target - set[ith_in_set-1]
    else
      current_target
    end
  end if knapsack[set.size][target][0] == 0
  
  subset.sort
end

def find_knapsack(amount, coins)
  coins.select {|coin| coin <= amount}.each do |coin|
    if amount - coin == 0
      return [coin]
    else
      knapsack = find_knapsack(amount-coin, coins-[coin])
      unless knapsack.empty?
        return (knapsack << coin).sort
      end
    end
  end
  return []
end

class TestKnapsackProblem < Test::Unit::TestCase
  def test_knapsack
    assert_equal([1, 2, 9, 10], find_knapsack(22, [10, 5, 2, 9, 1]))
    assert_equal([], find_knapsack(23, [1, 2, 5, 9, 10]))
    assert_equal([1, 5, 9, 15, 16, 30, 45], find_knapsack(121, [1, 2, 30, 9, 10, 15, 16, 5, 45]))
  end
  
  def test_knapsack_dynamically
    assert_equal([1, 2, 9, 10], find_knapsack_dynamically(22, [10, 5, 2, 9, 1]))
    assert_equal([], find_knapsack_dynamically(23, [1, 2, 5, 9, 10]))
    assert_equal([1, 5, 9, 15, 16, 30, 45], find_knapsack_dynamically(121, [1, 2, 30, 9, 10, 15, 16, 5, 45]))
  end
end