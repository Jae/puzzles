require "test/unit"

def edit_cost(operation, current = "", target = "")
  case
    when operation == :match && [current.size, target.size] == [1, 1]
      target == current ? 0 : Float::INFINITY
    when operation == :sub && [current.size, target.size] == [1, 1]
      target != current ? 1 : Float::INFINITY
    when operation == :insert && [current.size, target.size] == [0, 1]
      1
    when operation == :delete && [current.size, target.size] == [1, 0]
      1
    when operation == :swap && [current.size, target.size] == [2, 2]
      target == current.reverse ? 1 : Float::INFINITY
    else
      raise "unknown operation '#{operation}' from '#{current}' to '#{target}'"    
  end
end

def edit_distance(text, pattern)
  editions = Array.new(text.size+1) {[]}
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
        [:sub, text[text_index-1], pattern[pattern_index-1], editions[text_index-1][pattern_index-1]],
        [:insert, "", pattern[pattern_index-1], editions[text_index][pattern_index-1]],
        [:delete, text[text_index-1], "", editions[text_index-1][pattern_index]]
      ]
      operations << [:swap, text[text_index-2..text_index-1], pattern[pattern_index-2..pattern_index-1], editions[text_index-2][pattern_index-2]] if text_index > 1 and pattern_index > 1
      
      editions[text_index][pattern_index] = operations.map do |(operation, current, target, past_editions)|
        cost = edit_cost(operation, current, target) + past_editions[0]
        [cost, past_editions[1] + [operation]]
      end.min_by {|edition| edition[0]}
    end
  end
  
  editions[text.size][pattern.size]
end

def recursive_edit_distance(text, pattern)
  if text.size == 0 && pattern.size == 0
    [0, []]
  elsif text.size == 0
    [pattern.size, pattern.size.times.map {|_| :insert}]
  elsif pattern.size == 0
    [text.size, text.size.times.map {|_| :delete}]
  else
    operations = [
      [:match, text[-1], pattern[-1], text[0...-1], pattern[0...-1]],
      [:sub, text[-1], pattern[-1], text[0...-1], pattern[0...-1]],
      [:insert, "", pattern[-1], text, pattern[0...-1]],
      [:delete, text[-1], "", text[0...-1], pattern]
    ]
    operations << [:swap, text[-2..-1], pattern[-2..-1], text[0...-2], pattern[0...-2]] if text.size > 1 and pattern.size > 1
    
    operations.map do |(operation, current, target, remaining_text, remaining_pattern)|
      past_editions = recursive_edit_distance(remaining_text, remaining_pattern)
      cost = edit_cost(operation, current, target) + past_editions[0]
      [cost, past_editions[1].push(operation)]
    end.min_by {|edition| edition[0]}
  end
end

class TestEditDistance < Test::Unit::TestCase
  def test_edit_distance_for_single_swap
    assert_equal([1, [:match, :swap, :match, :match]], edit_distance("setve", "steve"))
  end
  
  def test_edit_distance_for_multiple_operations
    assert_equal([12, [:delete, :sub, :match, :match, :match, :match, :match, :insert, :sub, :match, :sub, :match, :match, :match, :match, :match, :delete, :delete, :sub, :sub, :sub, :sub, :match, :swap, :match]], edit_distance("Thou shalt not murder one", "You should not kill noe"))
  end
end