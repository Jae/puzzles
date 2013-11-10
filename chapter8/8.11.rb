require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def maximum_contiguous_sum(numbers)
  progress = DynamicProgress.new(numbers.size)
  
  progress.each do |i| #progress[i] = maximum contiguous sum of numbers from 1 to ith position
    if i == 0
      {:contiguous_range => (0...0)}
    else
      [
        {:contiguous_range => progress[i-1][:contiguous_range]},            # biggest run so far
        {:contiguous_range => (i-1...i)},                                   # new run
        {:contiguous_range => (progress[i-1][:contiguous_range].first...i)} # extends previous best run
      ].max_by {|e| e[:contiguous_range].map {|i| numbers[i]}.reduce(&:+) || 0}
    end
  end
  
  progress.goal[:contiguous_range].map {|i| numbers[i]}
end

class TestMaximumContiguousSum < Test::Unit::TestCase
  def test_maximum_contiguous_sum
    assert_equal([4, 1], maximum_contiguous_sum([4, 1, -2, -3, 2]))
    assert_equal([4, 1, -2, -3, 2, -1, 2, 3], maximum_contiguous_sum([4, 1, -2, -3, 2, -1, 2, 3]))
    assert_equal([59, 26, -53, 58, 97], maximum_contiguous_sum([31, -41, 59, 26, -53, 58, 97, -93, -23, 84]))
  end
end