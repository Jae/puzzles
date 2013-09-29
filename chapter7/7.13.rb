require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

class MinimumSetCover
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    input.values.flatten.uniq.sort == progress.map {|i,included| included && input[i] || []}.flatten.uniq.sort
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= {}
    
    (input.keys - progress.keys).map do |candidate|
      [progress.merge(candidate => true), progress.merge(candidate => false)]
    end.flatten(1)
  end
  
  def self.find(input)
    solutions = new.backtrack(Hash[(0...input.size).to_a.zip(input)])
    solutions.min_by do |solution| 
      solution.map {|set, included| included && 1 || 0}.reduce(&:+)
    end.map do |set, included|
      input[set] if included
    end.compact
  end
end

class TestMinimumSetCover < Test::Unit::TestCase
  def test_minimum_set_cover
    set_cover = MinimumSetCover.find([
      [:A, :D],
      [:B, :E],
      [:C, :F],
      [:D, :E, :G, :H],
      [:F, :K],
      [:G, :H, :I, :J, :K, :L],
      [:A, :B, :C, :D, :F, :G, :I]
    ])
    assert_equal(3, set_cover.size)
    assert(set_cover.include? [:B, :E])
    assert(set_cover.include? [:G, :H, :I, :J, :K, :L])
    assert(set_cover.include? [:A, :B, :C, :D, :F, :G, :I])
  end
end