require "test/unit"

def shuffled_text?(candidate, text1, text2)
  if candidate.size > 1
    (candidate[-1] == text1[-1] && shuffled_text?(candidate[0...-1], text1[0...-1], text2)) ||
    (candidate[-1] == text2[-1] && shuffled_text?(candidate[0...-1], text1, text2[0...-1]))
  else
    candidate[-1] == text1 || candidate[-1] == text2
  end
end



class TestShuffledText < Test::Unit::TestCase
  def test_shuffled_text
    assert_equal(true, shuffled_text?("cchocohilaptes", "chocolate", "chips"))
    assert_equal(false, shuffled_text?("chocochilatspe", "chocolate", "chips"))
  end
end