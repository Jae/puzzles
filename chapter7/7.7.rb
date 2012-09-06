require "test/unit"

def reduce_bandwidth(to_be_arranged, progress={size:0, arrangement:[]}, arranged={size:Float::INFINITY, arrangement:[]})
  if progress[:arrangement].size < to_be_arranged.size
    (to_be_arranged.keys - progress[:arrangement]).each do |candidate|
      unless progress[:arrangement].empty?
        edge_to_candidate = to_be_arranged[progress[:arrangement].last][candidate]
        if edge_to_candidate && arranged[:size] > [progress[:size], edge_to_candidate].max
          reduce_bandwidth(to_be_arranged, {size:[progress[:size], edge_to_candidate].max, arrangement:progress[:arrangement] + [candidate]}, arranged)
        end
      else
        reduce_bandwidth(to_be_arranged, {size:0, arrangement:[candidate]}, arranged)
      end
    end
  else
    if arranged[:size] > progress[:size]
      arranged[:size] = progress[:size]
      arranged[:arrangement] = progress[:arrangement]
    end
  end
  arranged[:arrangement]
end

class TestBandwidthReduction < Test::Unit::TestCase
  def test_reduce_bandwidth
    assert_block("should reduce bandwidth") do
      arrangement = reduce_bandwidth({:A=>{:B=>1, :C=>4, :D=>3}, :B=>{:A=>1, :C=>2}, :C=>{:A=>4, :B=>2, :D=>1}, :D=>{:A=>3, :C=>1}})
      [[:A,:B,:C,:D], [:D, :C, :B, :A]].include? arrangement
    end
  end
end