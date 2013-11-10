require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def compress(dictionary, text)
  progress = DynamicProgress.new(text.size, text.size-1) do |current_goal, operation|
    operation && operation[:text_range].to_a == (0..text.size-1).to_a && operation || current_goal
  end
  progress.each do |i, j| #progress[i,j] = compression for text of size i from 0 indexed jth character
    if i == 0
      {:text_range => (j..j+i-1), :compression => [], :cost => 0}
    elsif word = dictionary.find{|word| word == (text[j..j+i-1])}
      {:text_range => (j..j+i-1), :compression => [word], :cost => 1}
    elsif j+i-1 < text.size
      (j...j+i-1).map do |split|
        part1 = progress[split-j+1, j]
        part2 = progress[j+i-1-split, split+1]
        {:text_range => (j..j+i-1), :compression => part1[:compression] + part2[:compression], :cost => part1[:cost] + part2[:cost]}
      end.min_by{|op| op[:cost]}
    end
  end
  
  progress.goal[:compression]
end

class TestStringCompression < Test::Unit::TestCase
  def test_compress_string
    assert_equal(["b", "abab", "ba", "abab", "a"], compress(["a", "ba", "abab", "b"], "bababbaababa"))
  end
end