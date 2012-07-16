require "test/unit"

def edit_cost(operation, current = "", target = "")
  case
    when operation == :match && [current.size, target.size] == [1, 1]
      target == current ? 0 : Float::INFINITY
    when operation == :insert && [current.size, target.size] == [0, 1]
      1
    when operation == :delete && [current.size, target.size] == [1, 0]
      1
    else
      raise "unknown operation '#{operation}' from '#{current}' to '#{target}'"
  end
end

def edit_distance(text, pattern)
  editions = Array.new(text.size+1) {[]} # editions[i][j] = [min_cost, [operations]] done to match ith text with jth pattern
  (0..text.size).each do |text_index|
    editions[text_index][0] = [text_index, text_index.times.map {|_| :delete}]
  end
  (0..pattern.size).each do |pattern_index|
    editions[0][pattern_index] = [pattern_index, pattern_index.times.map {|_| :insert}]
  end

  (1..text.size).each do |text_index|
    (1..pattern.size).each do |pattern_index|
      operations = [
        [:match, text[text_index-1], pattern[pattern_index-1], editions[text_index-1][pattern_index-1]],
        [:insert, "", pattern[pattern_index-1], editions[text_index][pattern_index-1]],
        [:delete, text[text_index-1], "", editions[text_index-1][pattern_index]]
      ]
      
      editions[text_index][pattern_index] = operations.map do |(operation, current, target, past_editions)|
        cost = edit_cost(operation, current, target) + past_editions[0]
        [cost, past_editions[1] + [operation]]
      end.min_by {|edition| edition[0]}
    end
  end
  editions.last.last
end

def longest_common_subsequence(text1, text2)
  operations = edit_distance(text1, text2)[1]
  
  text1 = text1.chars.to_a
  operations.map do |operation|
    if operation == :match
      text1.shift
    else
      text1.shift && "" if operation == :delete
    end
  end.join("")
end

def shortest_common_supersequence(text1, text2)
  operations = edit_distance(text1, text2)[1]
  
  text1 = text1.chars.to_a
  text2 = text2.chars.to_a
  operations.map do |operation|
    if operation == :delete
      text1.shift
    elsif operation == :insert
      text2.shift
    else
      text1.shift
      text2.shift
    end
  end.join("")
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