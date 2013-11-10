require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

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
  progress = DynamicProgress.new(text.size, pattern.size)
  
  progress.each do |i, j| #progress[i,j] = edit operation to match ith character of text to jth character of pattern
    if i == 0 && j == 0
      {:cost => 0, :previous => nil, :operation => nil}
    elsif j == 0
      {:cost => i, :previous => [i-1, j], :operation => :delete}
    elsif i == 0
      {:cost => j, :previous => [i, j-1], :operation => :insert}
    else
      operations = [
        {
          :operation => :match, :previous => [i-1, j-1],
          :cost => progress[i-1, j-1][:cost] + edit_cost(:match, text[i-1], pattern[j-1]),
        },
        {
          :operation => :sub, :previous => [i-1, j-1],
          :cost => progress[i-1, j-1][:cost] + edit_cost(:sub, text[i-1], pattern[j-1]),
        },
        {
          :operation => :insert, :previous => [i, j-1],
          :cost => progress[i, j-1][:cost] + edit_cost(:insert, "", pattern[j-1]),
        },
        {
          :operation => :delete, :previous => [i-1, j],
          :cost => progress[i-1, j][:cost] + edit_cost(:delete, text[i-1], ""),
        }
      ]
      operations << {
        :operation => :swap, :previous => [i-2, j-2],
        :cost => progress[i-2, j-2][:cost] + edit_cost(:swap, text[i-2..i-1], pattern[j-2..j-1]),
      } if i > 1 && j > 1
      
      operations.min_by {|operation| operation[:cost]}
    end
  end
  
  [progress.operation_trails.last[:cost], progress.operation_trails.map {|op| op[:operation]}.compact]
end

class TestEditDistance < Test::Unit::TestCase
  def test_edit_distance_for_single_swap
    assert_equal([1, [:match, :swap, :match, :match]], edit_distance("setve", "steve"))
  end
  
  def test_edit_distance_for_multiple_operations
    assert_equal([12, [:delete, :sub, :match, :match, :match, :match, :match, :insert, :sub, :match, :sub, :match, :match, :match, :match, :match, :delete, :delete, :sub, :sub, :sub, :sub, :match, :swap, :match]], edit_distance("Thou shalt not murder one", "You should not kill noe"))
  end
end