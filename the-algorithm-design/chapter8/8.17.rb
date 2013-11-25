require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def city_walks(city_size, bad_neighborhoods)
  progress = DynamicProgress.new(city_size[0], city_size[1]) do |current_goal, operation|
    operation && operation[:intersection] == [city_size[0], city_size[1]] && operation
  end
  progress.each do |i,j| #progress[i,j] = shortest route to [i,j] intersection without going through bad neighbourhoods
    unless bad_neighborhoods.include?([i,j])
      if i == 0 && j == 0
        {:intersection => [i,j], :cost => 0, :routes_to_intersection => 1}
      else
        cost, min_routes = [[i-1, j], [i, j-1]].select {|prev_i, prev_j| progress[prev_i, prev_j]}.map do |prev_i, prev_j|
          {:cost => progress[prev_i, prev_j][:cost] + 1, :routes_to_intersection => progress[prev_i, prev_j][:routes_to_intersection]}
        end.group_by {|op| op[:cost]}.min_by{|cost, ops| cost}
        
        {:intersection => [i,j], :cost => cost, :routes_to_intersection => min_routes.map {|e|e[:routes_to_intersection]}.reduce(&:+)} if min_routes
      end
    end
  end
  progress.goal[:routes_to_intersection]
end

class TestCityWalk < Test::Unit::TestCase
  def test_city_walk
    assert_equal(2, city_walks([3,3], [[2,1], [1,2]]))
    assert_equal(11, city_walks([4,4], [[1,1], [2,1], [0,3], [1,3]]))
  end
end