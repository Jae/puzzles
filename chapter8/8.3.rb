require "test/unit"

def longest_common_substring(text1, text2)
  ""
end

class TestEditDistance < Test::Unit::TestCase
  def test_longest_common_substring
    assert_equal("ograph", longest_common_substring("photograph", "tomography"))
  end
end