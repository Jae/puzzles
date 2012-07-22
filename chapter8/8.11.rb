require "test/unit"

def maximum_contiguous_sum(numbers)
  maximum_contiguous_numbers = [0, []]
  numbers.each_index do |i|
    (0...numbers.size-i).each do |contiguous_size|
      contiguous_sum = numbers[i..(contiguous_size+i)].inject(0) {|memo, number| memo + number}
      if maximum_contiguous_numbers[0] < contiguous_sum
        maximum_contiguous_numbers = [contiguous_sum, numbers[i..(contiguous_size+i)]]
      elsif maximum_contiguous_numbers[0] == contiguous_sum && contiguous_size < maximum_contiguous_numbers[1].size
        maximum_contiguous_numbers = [contiguous_sum, numbers[i..(contiguous_size+i)]]
      end
    end
    numbers[i...numbers.size]
  end
  maximum_contiguous_numbers[1]
end

class TestMaximumContiguousSum < Test::Unit::TestCase
  def test_maximum_contiguous_sum
    assert_equal([4, 1], maximum_contiguous_sum([4, 1, -2, -3, 2]))
    assert_equal([2, -1, 2, 3], maximum_contiguous_sum([4, 1, -2, -3, 2, -1, 2, 3]))
  end
end