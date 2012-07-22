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
    if knapsack[ith_in_set][current_target][1]
      subset << set[ith_in_set-1]
      current_target - set[ith_in_set-1]
    else
      current_target
    end
  end if knapsack[set.size][target][0] == 0
  
  subset.sort
end

def partition(set)
  total_sum = set.inject(0) {|memo, i| memo+i}
  return [[],[]] unless total_sum % 2 == 0
  first_partition = find_knapsack_dynamically(total_sum/2, set)
  second_partition = find_knapsack_dynamically(total_sum/2, set-first_partition)
  [first_partition, second_partition].sort
end

class TestSetPartition < Test::Unit::TestCase
  def test_partition_set_into_two_of_equal_sum
    assert_equal([[1, 4], [2, 3]], partition([1, 2, 3, 4]))
    assert_equal([[1, 3, 10], [5, 9]], partition([1, 3, 5, 9, 10]))
  end
end