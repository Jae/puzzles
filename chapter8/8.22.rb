require "test/unit"

def multiple_of(factors)
  alphabets = ["a", "b", "c"]
  [
    ["a", "c", "c"],
    ["a", "a", "b"],
    ["c", "c", "c"]
  ][alphabets.index(factors[0])][alphabets.index(factors[1])] if factors[0] && factors[1]
end

def factors_of(to_be_factored)
  factors = []
  alphabets = ["a", "b", "c"]
  [
    ["a", "c", "c"],
    ["a", "a", "b"],
    ["c", "c", "c"]
  ].each_with_index do |products, first_factor|
    products.each_with_index do |product, second_factor|
      factors << [alphabets[first_factor], alphabets[second_factor]] if product == to_be_factored
    end
  end
  factors
end

def dynamic_parenthesize_multiplication(multiplication, product)
  alphabets = ["a", "b", "c"]
  parenthesized = Array.new(multiplication.size) { Array.new(multiplication.size) } # parenthesized[i][j] = {"a" =>[], "b" => [], "c" => []} submultiplication of size i+1 from j index product to each alphabet
  
  parenthesized.each_index do |j|
    parenthesized[0][j] = Hash[alphabets.map do |alphabet|
      if multiplication[j..j] == alphabet
        [alphabet, [alphabet]]
      else
        [alphabet, []]
      end
    end]
    
    parenthesized[1][j] = Hash[alphabets.map do |alphabet|
      if multiple_of(multiplication[j..j+1].chars.to_a) == alphabet
        [alphabet, multiplication[j..j+1].chars.to_a]
      else
        [alphabet, []]
      end
    end]
  end

  (2...parenthesized.size).each do |i|
    parenthesized[i].each_index do |j|
      parenthesized[i][j] = {"a" => [], "b" => [], "c" => []}
      ["a", "b", "c"].each do |character|
        factors_of(character).each do |factors|
          sub_multiplication = multiplication[j..j+i]
          (1...sub_multiplication.size).each do |divider|
            first_groups = parenthesized[divider-1][j][factors[0]]
            second_groups = parenthesized[sub_multiplication.size-divider-1][j+divider][factors[1]]
            
            unless first_groups.empty? || second_groups.empty?
              parenthesized[i][j][character] = [first_groups] + [second_groups]
              break
            end
          end
        end
      end
    end
  end
  
  parenthesized.last.first[product]
end

class TestParenthesizeMultiplication < Test::Unit::TestCase
  def test_parenthesize_multiplication
    assert_equal([["a"], [[["b"], ["c", "a"]], ["b", "c"]]], dynamic_parenthesize_multiplication("abcabc", "a"))
    assert_equal([["b"], ["b", "b"]], dynamic_parenthesize_multiplication("bbb", "a"))
    assert_equal([["b"], [["b"], [["b"], ["b", "a"]]]], dynamic_parenthesize_multiplication("bbbba", "a"))
    assert_equal([[["b", "b"], ["b"]], ["b", "a"]], dynamic_parenthesize_multiplication("bbbba", "c"))
  end
end