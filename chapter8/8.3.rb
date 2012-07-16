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

def dynamic_longest_common_sequence(text1, text2)
  editions = Array.new(text1.size+1) {[]} # editions[i][j] = [min_cost, [operations]] done to match ith text1 with jth text2
  (0..text1.size).each do |text1_index|
    editions[text1_index][0] = [text1_index, text1_index.times.map {|_| :delete}]
  end
  (0..text2.size).each do |text2_index|
    editions[0][text2_index] = [text2_index, text2_index.times.map {|_| :insert}]
  end

  (1..text1.size).each do |text1_index|
    (1..text2.size).each do |text2_index|
      operations = [
        [:match, text1[text1_index-1], text2[text2_index-1], editions[text1_index-1][text2_index-1]],
        [:insert, "", text2[text2_index-1], editions[text1_index][text2_index-1]],
        [:delete, text1[text1_index-1], "", editions[text1_index-1][text2_index]]
      ]
      
      editions[text1_index][text2_index] = operations.map do |(operation, current, target, past_editions)|
        cost = edit_cost(operation, current, target) + past_editions[0]
        [cost, past_editions[1] + [operation]]
      end.min_by {|edition| edition[0]}
    end
  end
  
  matches = [""]
  editions[text1.size][text2.size][1].inject(text1.chars.to_a) do |memo, operation|
    if operation == :delete
      memo.shift
      matches << ""
    elsif operation == :insert
      matches << ""
    elsif operation == :match
      matches[-1] = matches[-1] + memo.shift
    end
    memo
  end
  matches.max_by {|match| match.size}
end

def longest_common_sequence(text1, text2)
  
end

class TestLongestCommonSequence < Test::Unit::TestCase
  def test_dynamic_longest_common_sequence
    assert_equal("ograph", dynamic_longest_common_sequence("photograph", "tomography"))
  end
  
  def test_longest_common_sequence
    assert_equal("ograph", longest_common_sequence("photograph", "tomography"))
  end
end