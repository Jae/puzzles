require "test/unit"

def city_walks(city_size, bad_neighborhoods)
  walks = Array.new(city_size[0]) { Array.new(city_size[1]) } # walks[i][j] = previous minimum walk position that lead to city[i][j]
  walks[0][0] = [0,0]
  
  next_stops = Proc.new do |stop|
    [
                            [stop[0], stop[1]-1],
      [stop[0]-1, stop[1]],                       [stop[0]+1, stop[1]],
                            [stop[0], stop[1]+1]
    ].select do |(x,y)|
      x >= 0 && y >= 0 && x < city_size[0] && y < city_size[1] &&
      !bad_neighborhoods.include?([x,y]) && 
      walks[x][y].nil?
    end
  end

  last_stops = [[0,0]]
  until last_stops.all? {|stop| next_stops.call(stop).empty? }
    last_stops = last_stops.inject([]) do |memo, stop|
      next_stops.call(stop).each do |next_stop|
        walks[next_stop[0]][next_stop[1]] = stop
        memo << next_stop
      end
      memo
    end
  end
  
  if walks[city_size[0]-1][city_size[1]-1]
    journey = [[city_size[0]-1, city_size[1]-1]]
    until journey.first == [0, 0]
      journey.unshift(walks[journey.first[0]][journey.first[1]])
    end
    journey
  else
    []
  end
end

class TestCityWalk < Test::Unit::TestCase
  def test_city_walk
    assert_equal([], city_walks([3,3], [[2,1], [1,2]]))
    assert_equal([[0, 0], [0, 1], [0, 2], [1, 2], [2, 2], [2, 3], [3, 3]], city_walks([4,4], [[1,1], [2,1], [3,2], [4,0], [0,4], [1,3]]))
  end
end