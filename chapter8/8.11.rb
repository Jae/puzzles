require "test/unit"

def maximum_contiguous_sum(numbers)
  sum = [numbers[0], [0]]

  (1...numbers.size).each do |i|
    sums = []
    sums << sum                                                                # leave the run
    sums << [sum[0] + numbers[i], sum[1] + [i]] if sum[1].last == i-1          # continue the run
    sums << [numbers[i], [i]]                                                  # start a new run
    sums << [numbers[sum[1].first..i].inject(0) {|memo, number| memo += number}, (sum[1].first..i).to_a] unless sum[1].last == i-1 # bridge the run
    sum = sums.max_by {|(sum,_)| sum}
  end

  sum[1].map {|i| numbers[i]}
end

class TestMaximumContiguousSum < Test::Unit::TestCase
  def test_maximum_contiguous_sum
    assert_equal([4, 1], maximum_contiguous_sum([4, 1, -2, -3, 2]))
    assert_equal([4, 1, -2, -3, 2, -1, 2, 3], maximum_contiguous_sum([4, 1, -2, -3, 2, -1, 2, 3]))
    assert_equal([59, 26, -53, 58, 97], maximum_contiguous_sum([31, -41, 59, 26, -53, 58, 97, -93, -23, 84]))
  end
end