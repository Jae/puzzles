require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def common_sequence(text1, text2)
  progress = DynamicProgress.new(text1.size, text2.size) do |current_goal, operation|
    current_goal && current_goal[:lcs] > operation[:lcs] && current_goal || operation
  end
  
  progress.each do |i, j| #progress[i,j] = longest common subsequence of text1[0...i] and text2[0...j]
    if i == 0 || j == 0
      {:lcs => 0, :previous => nil, :common_subsequence => "", :action => :skip}
    else
      if text1[i-1] == text2[j-1]
        {:lcs => progress[i-1,j-1][:lcs] + 1, :previous => [i-1,j-1], :index => [i,j], :action => :match}
      else
        [
          {:lcs => progress[i,j-1][:lcs], :previous => [i,j-1], :index => [i,j], :action => :skip},
          {:lcs => progress[i-1,j][:lcs], :previous => [i-1,j], :index => [i,j], :action => :skip}
        ].max_by {|operation| operation[:lcs]}
      end
    end
  end

  progress.operation_trails
end

def longest_common_subsequence(text1, text2)
  common_sequence(text1, text2).select do |operation|
    operation[:action] == :match
  end.map do |operation|
    text1[operation[:index].first-1]
  end.join
end

def shortest_common_supersequence(text1, text2)
  (common_sequence(text1, text2).select do |operation|
    operation[:action] == :match
  end << {:index => [text1.size+1, text2.size+1], :last => true}).each_with_index.inject({:supersequence => "", :matches => [{:i => 0, :j => 0}]}) do |memo, (operation, index)|    
    memo[:supersequence] << text1[memo[:matches].last[:i]...operation[:index].first - 1]
    memo[:supersequence] << text2[memo[:matches].last[:j]...operation[:index].last - 1]
    memo[:supersequence] << text1[operation[:index].first - 1] unless operation[:last]
    
    memo[:matches] << {:i => operation[:index].first, :j => operation[:index].last}
    memo
  end[:supersequence]
end

class TestLongestCommonSequence < Test::Unit::TestCase
  def test_longest_common_subsequence
    assert_equal("tograph", longest_common_subsequence("photograph", "tomography"))
    assert_equal("eca", longest_common_subsequence("democrat", "republican"))
  end
  
  def test_shortest_common_supersequence
    assert_equal("photomography", shortest_common_supersequence("photograph", "tomography"))
  end
end