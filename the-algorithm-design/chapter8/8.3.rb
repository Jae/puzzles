require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def dynamic_longest_common_string(text1, text2)
  progress = DynamicProgress.new(text1.size, text2.size) do |current_goal, operation|
    current_goal && current_goal[:length] > operation[:length] && current_goal || operation
  end
  
  progress.each do |i, j| #progress[i,j] = length of common string ending at ith character of text1 and jth character of text2
    if i == 0 && j == 0
      {:length => 0, :previous => nil, :character => nil}
    elsif i == 0
      {:length => 0, :previous => nil, :character => nil}
    elsif j == 0
      {:length => 0, :previous => nil, :character => nil}
    else
      if text1[i-1] == text2[j-1]
        {:length => progress[i-1, j-1][:length] + 1, :previous => [i-1, j-1], :character => text1[i-1]}
      else
        {:length => 0, :previous => nil, :character => nil}
      end
    end
  end

  progress.operation_trails.map {|operation| operation[:character]}.compact.join
end

class TestLongestCommonString < Test::Unit::TestCase
  def test_dynamic_longest_common_string
    assert_equal("ograph", dynamic_longest_common_string("photograph", "tomography"))
  end
end