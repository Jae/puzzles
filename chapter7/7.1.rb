require "test/unit"

def derangement(to_be_deranged, progress=[], deranged=[])
  if progress.size < to_be_deranged.size
    (to_be_deranged[0...progress.size] + to_be_deranged[progress.size+1..-1]).reject {|candidate| progress.include? candidate}.each do |candidate|
      derangement(to_be_deranged, progress + [candidate], deranged)
    end
  else
    deranged << progress
  end
  deranged
end

class TestDerangement < Test::Unit::TestCase
  def test_derangement
    assert_equal([[2, 3, 1], [3, 1, 2]], derangement([1,2,3]))
    assert_equal([[2, 1, 4, 3],[2, 3, 4, 1],[2, 4, 1, 3],[3, 1, 4, 2],[3, 4, 1, 2],[3, 4, 2, 1],[4, 1, 2, 3],[4, 3, 1, 2],[4, 3, 2, 1]], derangement([1,2,3,4]))
  end
end