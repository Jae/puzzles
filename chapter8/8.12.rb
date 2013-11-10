require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def minimum_split_cost(split_positions, text_size)
  progress = DynamicProgress.new(text_size, text_size) do |current_goal, operation|
    operation && operation[:text_range].to_a == (1..text_size).to_a && operation || current_goal
  end
  progress.each do |i, j| #progress[i,j] = minimum split costs of text of size i from jth character
    split_positions.select do |split|
      j < split && split < j + i - 1
    end.map do |split|
      part1 = progress[split - j + 1, j] || {:cost => 0, :text_range => (j..split), :minimum_splits => []}
      part2 = progress[i - (split - j + 1), split+1] || {:cost => 0, :text_range => (split+1...j+i), :minimum_splits => []}
      {:cost => i + part1[:cost] + part2[:cost], :text_range => (j...j+i), :minimum_splits => [split] + part1[:minimum_splits] + part2[:minimum_splits]}
    end.min_by {|e| e[:cost]}
  end
  
  [progress.goal[:cost], progress.goal[:minimum_splits]]
end

class TestMinimumCostOfSplit < Test::Unit::TestCase
  def test_minimum_split_cost
    assert_equal([37, [10, 3, 8]], minimum_split_cost([3, 8, 10], 20))
    assert_equal([132, [15, 8, 3, 10, 28, 21, 35, 31, 39]], minimum_split_cost([3, 8, 10, 15, 21, 28, 31, 35, 39], 40))
  end
end