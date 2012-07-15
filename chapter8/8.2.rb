require "test/unit"

def shuffled_text?(shuffle, text1, text2)
  shuffled = Array.new(text1.size+1) {[]} # shuffled[i][j] = whether or not shuffle[i+j] is made up of first i and j characters from text1 and text2
  (0..text1.size).each do |text1_index|
    shuffled[text1_index][0] = text1_index == 0 ? true : shuffle[0...text1_index] == text1[0...text1_index]
  end
  (0..text2.size).each do |text2_index|
    shuffled[0][text2_index] = text2_index == 0 ? true : shuffle[0...text2_index] == text2[0...text2_index]
  end
  
  (1..text1.size).each do |text1_index|
    (1..text2.size).each do |text2_index|
      
      shuffled[text1_index][text2_index] ||= 
        (shuffle[text1_index+text2_index-1] == text1[text1_index-1] && shuffled[text1_index-1][text2_index]) ||
        (shuffle[text1_index+text2_index-1] == text2[text2_index-1] && shuffled[text1_index][text2_index-1])
    end
  end
  shuffled.last.last
end

def recursive_shuffled_text?(shuffle, text1, text2)
  if shuffle.size > 1
    (shuffle[-1] == text1[-1] && recursive_shuffled_text?(shuffle[0...-1], text1[0...-1], text2)) ||
    (shuffle[-1] == text2[-1] && recursive_shuffled_text?(shuffle[0...-1], text1, text2[0...-1]))
  else
    shuffle[-1] == text1 || shuffle[-1] == text2
  end
end

class TestShuffledText < Test::Unit::TestCase
  def test_shuffled_text
    assert_equal(true, shuffled_text?("cchocohilaptes", "chocolate", "chips"))
    assert_equal(false, shuffled_text?("chocochilatspe", "chocolate", "chips"))
  end
end