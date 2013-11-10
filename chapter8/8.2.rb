require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def shuffled_text2?(shuffle, text1, text2)
  progress = DynamicProgress.new(text1.size, text2.size)
  
  progress.each do |i, j| # progress[i,j] = whether or not shuffle[i+j] is made up of first i and j characters from text1 and text2
    if i == 0 && j == 0
      {:shuffled => true, :previous => nil}
    elsif i == 0
      {:shuffled => text2[0..j-1] == shuffle[0..j-1], :previous => [0, j-1]}
    elsif j == 0
      {:shuffled => text1[0..i-1] == shuffle[0..i-1], :previous => [i-1, 0]}
    else
      [
        {:shuffled => progress[i-1, j][:shuffled] && text1[i-1] == shuffle[i + j - 1], :previous => [i-1, j]},
        {:shuffled => progress[i, j-1][:shuffled] && text2[j-1] == shuffle[i + j - 1], :previous => [i, j-1]}
      ].find {|operation| operation[:shuffled] == true} || {:shuffled => false, :previous => nil}
    end
  end
  
  progress.operation_trails.last[:shuffled]
end

class TestShuffledText < Test::Unit::TestCase
  def test_shuffled_text
    assert_equal(true, shuffled_text2?("cchocohilaptes", "chocolate", "chips"))
    assert_equal(false, shuffled_text2?("chocochilatspe", "chocolate", "chips"))
  end
end