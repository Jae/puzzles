require "test/unit"

def permutate(to_be_permutated, progress=[], permutated=[])
  if progress.size < to_be_permutated.size
    grouped_by_member = to_be_permutated.group_by {|e| e}
    progress.each {|e| grouped_by_member[e].pop}
    grouped_by_member.values.flatten.uniq.each do |candidate|
      permutate(to_be_permutated, progress + [candidate], permutated)
    end
  else
    permutated << progress
  end
  permutated
end

class TestPermutation < Test::Unit::TestCase
  def test_permutation_of_multiset
    assert_equal([[1,1,2,2],[1,2,1,2],[1,2,2,1],[2,1,1,2],[2,1,2,1],[2,2,1,1]], permutate([1,1,2,2]))
  end
end