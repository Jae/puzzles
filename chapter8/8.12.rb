require "test/unit"

def dynamic_minimum_split_cost(split_positions, string_size)
  splits = Array.new(string_size) {[]} # splits[i][j] = [min_split_cost, splits] to split substring of i size from jth index
  (0..string_size).each do |i|
    splits[i][0] = [0, []]
  end
  (0..split_positions.size).each do |j|
    splits[0][j] = [0, []]
  end
  
  (1..string_size).each do |i|
    (1..split_positions.size).each do |j|
      legal_splits = split_positions[0...j].select {|split_position| i > split_position}
      if legal_splits.empty?
        splits[i][j] = splits[i][legal_splits.size]
      else
        
        splits[i][j] = [
          [splits[i][legal_splits.size-1][0]+i, splits[i][legal_splits.size-1][1] + [legal_splits.last]],
          []
        ].min_by {|(split_cost, _)| split_cost}
      end
    end
  end
  
  splits[string_size][split_positions.size]
end

def recursive_minimum_split_cost(split_positions, string_size, string_from_index = 0)
  legal_positions = split_positions.select do |split_position|
    (string_from_index < split_position) && (split_position < string_from_index + string_size)
  end

  if legal_positions.empty?
    [0, []]
  elsif legal_positions.size == 1
    [string_size, legal_positions]
  else
    legal_positions.map do |split_position|
      part1 = recursive_minimum_split_cost(split_positions, split_position - string_from_index, string_from_index)
      part2 = recursive_minimum_split_cost(split_positions, string_size + string_from_index - split_position, split_position)

      [
        part1[0] + part2[0] + string_size, [split_position] + part1[1] + part2[1]
      ]
    end.min_by {|(split_cost, _)| split_cost}
  end
end

class TestMinimumCostOfSplit < Test::Unit::TestCase
  def test_minimum_split_cost
    assert_equal([37, [10, 3, 8]], recursive_minimum_split_cost([3, 8, 10], 20))
    assert_equal([132, [15, 8, 3, 10, 28, 21, 35, 31, 39]], recursive_minimum_split_cost([3, 8, 10, 15, 21, 28, 31, 35, 39], 40))
  end
end