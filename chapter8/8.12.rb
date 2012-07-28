require "test/unit"

def dynamic_minimum_split_cost(split_positions, string_size)
  splits = Array.new(string_size+1) {[]} # splits[i][j] = [min_split_cost, splits] to split substring of size i from jth index
  (0...string_size).each do |jth_index|
    splits[0][jth_index] = [0, []]
    splits[1][jth_index] = [0, []]
  end
  
  (2..string_size).each do |size_i|
    (0..string_size).each do |jth_index|
      legal_positions = split_positions.select do |split_position|
        (jth_index < split_position) && (split_position < jth_index + size_i)
      end
      
      if legal_positions.empty?
        splits[size_i][jth_index] = [0, []]
      elsif legal_positions.size == 1
        splits[size_i][jth_index] = [size_i, legal_positions]
      else
        splits[size_i][jth_index] = legal_positions.map do |split_position|
          part1 = splits[split_position - jth_index][jth_index]
          part2 = splits[size_i + jth_index - split_position][split_position]

          [
            part1[0] + part2[0] + size_i, [split_position] + part1[1] + part2[1]
          ]
        end.min_by {|(split_cost, _)| split_cost}
      end
    end
  end
  
  splits[string_size][0]
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
  def test_recursive_minimum_split_cost
    assert_equal([37, [10, 3, 8]], recursive_minimum_split_cost([3, 8, 10], 20))
    assert_equal([132, [15, 8, 3, 10, 28, 21, 35, 31, 39]], recursive_minimum_split_cost([3, 8, 10, 15, 21, 28, 31, 35, 39], 40))
  end
  
  def test_dynamic_minimum_split_cost
    assert_equal([37, [10, 3, 8]], dynamic_minimum_split_cost([3, 8, 10], 20))
    assert_equal([132, [15, 8, 3, 10, 28, 21, 35, 31, 39]], dynamic_minimum_split_cost([3, 8, 10, 15, 21, 28, 31, 35, 39], 40))
  end
end