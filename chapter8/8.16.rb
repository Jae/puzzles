require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def city_walk(city_size, bad_neighborhoods)
  progress = DynamicProgress.new(city_size[0], city_size[1]) do |current_goal, operation|
    operation && operation[:intersection] == [city_size[0], city_size[1]] && operation
  end
  progress.each do |i,j| #progress[i,j] = shortest route to [i,j] intersection without going through bad neighbourhoods
    unless bad_neighborhoods.include?([i,j])
      if i == 0 && j == 0
        {:intersection => [i,j], :previous => nil, :cost => 0}
      else
        [[i-1, j], [i, j-1]].select {|prev_i, prev_j| progress[prev_i, prev_j]}.map do |prev_i, prev_j|
          {:intersection => [i,j], :previous => [prev_i, prev_j], :cost => progress[prev_i, prev_j][:cost] + 1}
        end.min_by {|op| op[:cost]}
      end
    end
  end
  progress.goal && progress.operation_trails.map {|op| op[:intersection]} || []
end

class TestCityWalk < Test::Unit::TestCase
  def test_city_walk
    assert_equal([], city_walk([3,3], [[2,1], [1,2], [3,1], [2,3]]))
    assert_equal([[0, 0], [0, 1], [0, 2], [1, 2], [2, 2], [2, 3], [3, 3], [4, 3]], city_walk([4,3], [[1,1], [2,1], [3,2], [3,0], [0,3], [1,3]]))
  end
end