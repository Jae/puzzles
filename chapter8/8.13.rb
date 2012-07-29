require "test/unit"

def dynamic_compress(dictionary, text)
  compressions = Array.new(text.size + 1) {[]} # compressions[i][j] = [compression_cost, compression] to compress sub-text of size i from jth index
  (0..text.size).each do |jth_index|
    compressions[0][jth_index] = [0, []]
  end
  
  (1..text.size).each do |size_i|
    (0..text.size).each do |jth_index|
      
      compressions[size_i][jth_index] = dictionary.inject([]) do |memo, word|
        sub_text = text[jth_index...(jth_index + size_i)]
        while match = Regexp.new(word).match(sub_text, match && match.end(0) || 0)
          part1 = compressions[match.begin(0)][jth_index]
          part2 = compressions[sub_text.size - match.end(0)][jth_index + match.end(0)]
          memo << [part1[0] + 1 + part2[0], part1[1] + [word] + part2[1]]
        end

        memo
      end.min_by {|(cost, _)| cost}
      
    end
  end
  
  compressions[text.size][0]
end

def recursive_compress(dictionary, text)
  return [0, []] if text.empty?
  
  dictionary.inject([]) do |compressions, word|
    while match = Regexp.new(word).match(text, match && match.end(0) || 0)
      part1 = recursive_compress(dictionary, text[0...match.begin(0)])
      part2 = recursive_compress(dictionary, text[match.end(0)..-1])
      
      compressions << [part1[0] + 1 + part2[0], part1[1] + [word] + part2[1]]
    end
    
    compressions
  end.min_by {|(cost, _)| cost}
end

class TestStringCompression < Test::Unit::TestCase
  def test_compress_string
    assert_equal(["b", "abab", "ba", "abab", "a"], recursive_compress(["a", "ba", "abab", "b"], "bababbaababa")[1])
    assert_equal(["b", "abab", "ba", "abab", "a"], dynamic_compress(["a", "ba", "abab", "b"], "bababbaababa")[1])
  end
end