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

def longest_common_sequence(text1, text2)
  operations = edit_distance(text1, text2)[1]
  
  matches = ""
  operations.inject(text1.chars.to_a) do |memo, operation|
    memo.shift if operation == :delete
    matches << memo.shift if operation == :match
    memo
  end
  matches
end

def shortest_common_sequence(text1, text2)
  ""
end

class TestLongestCommonSequence < Test::Unit::TestCase
  def test_longest_common_sequence
    assert_equal("tograph", longest_common_sequence("photograph", "tomography"))
    assert_equal("eca", longest_common_sequence("democrat", "republican"))
  end
  
  def test_shortest_common_sequence
    assert_equal("ograph", shortest_common_sequence("photograph", "tomography"))
  end
end