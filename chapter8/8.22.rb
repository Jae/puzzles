require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def multiple_of(factors)
  alphabets = ["a", "b", "c"]
  [
    ["a", "c", "c"],
    ["a", "a", "b"],
    ["c", "c", "c"]
  ][alphabets.index(factors[0])][alphabets.index(factors[1])] if factors[0] && factors[1]
end

def factors_of(to_be_factored)
  alphabets = ["a", "b", "c"]
  [
    ["a", "c", "c"],
    ["a", "a", "b"],
    ["c", "c", "c"]
  ].each_with_index.reduce([]) do |factors, (products, first_factor)|
    products.each_with_index do |product, second_factor|
      factors << [alphabets[first_factor], alphabets[second_factor]] if product == to_be_factored
    end
    factors
  end
end

def parenthesize(multiplication, product)
  alphabets = ["a", "b", "c"]
  multiplication = multiplication.chars.to_a
  progress = DynamicProgress.new(multiplication.size, multiplication.size-1, alphabets.size-1) do |current_goal, operation|
    target_alphabet = alphabets.index(product)
    operation && operation[:index] == [multiplication.size, 0, target_alphabet] && operation || current_goal
  end
  progress.each do |i,j,k| #progress[i,j,k] = parenthesization of multiplication of size i from jth zero indexed character to produce kth zero indexed alphabet
    if j + i - 1 < multiplication.size
      if i > 2
        factors_of(alphabets[k]).map do |factor1, factor2|
          (j...j+i-1).map do |split|
            part1 = progress[split-j+1,j,alphabets.index(factor1)]
            part2 = progress[j+i-1-split,split+1,alphabets.index(factor2)]
            part1 && part2 && {:index => [i,j,k], :multiplication => [part1[:multiplication], part2[:multiplication]]} || nil 
          end
        end.flatten.compact.uniq.first
      elsif i == 1
        {:index => [i,j,k], :multiplication => alphabets[k]} if multiplication[j] == alphabets[k]
      elsif i == 2
        factors_of(alphabets[k]).select do |factor1, factor2|
          "#{factor1}#{factor2}" == multiplication[j..j+i-1].join("")
        end.map do |factor1, factor2|
          {:index => [i,j,k], :multiplication => [factor1, factor2]}
        end.first# .tap {|e| p ["p2", e]}
      end
    end
  end
  
  progress.goal[:multiplication]
end

class TestParenthesizeMultiplication < Test::Unit::TestCase
  def test_parenthesize_multiplication
    assert_equal(["a", [["b", ["c", "a"]], ["b", "c"]]], parenthesize("abcabc", "a"))
    assert_equal(["b", ["b", "b"]], parenthesize("bbb", "a"))
    assert_equal([["b", "b"], [["b", "b"], "a"]], parenthesize("bbbba", "a"))
    assert_equal([[["b", "b"], "b"], ["b", "a"]], parenthesize("bbbba", "c"))
  end
end