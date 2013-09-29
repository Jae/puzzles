require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

class BandwidthReduction
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    progress.size == input.size
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= []
    
    (input.keys - progress).map do |candidate|
      progress + [candidate]
    end
  end
  
  def self.reduce(input, &cost_function)
    new.backtrack(input).min_by do |arrangement|
      input.map do |from,neighbours|
        neighbours.map {|to| (arrangement.index(from) - arrangement.index(to)).abs}
      end.flatten.reduce(&:+)/2
    end
  end
end

class TestBandwidthReduction < Test::Unit::TestCase
  def test_bandwidth_reduction
    arrangement = BandwidthReduction.reduce({1=>[8], 2=>[7, 8], 3=>[6, 7], 4=>[5, 6], 5=>[4], 6=>[4], 7=>[2, 3], 8=>[1, 2]})
    assert_equal([1, 8, 2, 7, 3, 6, 4, 5], arrangement)
  end
end