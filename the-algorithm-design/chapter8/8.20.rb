require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def dial_distance(first_number, second_number)
  dial_pad = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    ["*", 0, "#"]
  ]
  
  [first_number, second_number].each_cons(2).inject(0) do |memo, (from, to)|
    from_row = dial_pad.index {|row| row.include? from}
    from_column = dial_pad[from_row].index {|column| column == from}

    to_row = dial_pad.index {|row| row.include? to}
    to_column = dial_pad[to_row].index {|column| column == to}

    memo += ((from_row - to_row) ** 2 + (from_column - to_column) ** 2) ** 0.5
  end
end

def dial_numbers(numbers)
  dialpad = [1,2,3,4,5,6,7,8,9,0,"*","#"]
  
  progress = DynamicProgress.new(numbers.size-1, dialpad.size-1, dialpad.size-1) do |current_goal, operation|
    if operation && operation[:index] == numbers.size-1
      !current_goal && operation || operation[:cost] < current_goal[:cost] && operation || current_goal
    else
      current_goal
    end
  end
  progress.each do |i,j,k|  #progress[i,j,k] = laziest way to dial upto ith zero indexed number such that left and right fingers finish on jth and kth zero indexed number in dialpad
    number = numbers[i]
    if dialpad[j] == number && dialpad[k] != number #left finger on the ith number
      if i == 0
        {:cost => dial_distance("*", number), :key_press => "l#{number}".to_sym, :previous => nil, :index => i} if dialpad[k] == "#"
      else
        (0...dialpad.size).select do |prev_j|
          progress[i-1, prev_j, k] && dialpad[prev_j] != dialpad[k] && (numbers[0...i] + ["*", "#"]).include?(dialpad[prev_j])
        end.map do |prev_j|
          {:cost => progress[i-1, prev_j, k][:cost] + dial_distance(dialpad[prev_j], number), :key_press => "l#{number}".to_sym, :previous => [i-1, prev_j, k], :index => i}
        end.min_by {|key_press| key_press[:cost]}
      end
    elsif dialpad[j] != number && dialpad[k] == number #right finger on the ith number
      if i == 0
        {:cost => dial_distance("#", number), :key_press => "r#{number}".to_sym, :previous => nil, :index => i} if dialpad[j] == "*"
      else
        (0...dialpad.size).select do |prev_k|
          progress[i-1, j, prev_k] && dialpad[j] != dialpad[prev_k] && (numbers[0...i] + ["*", "#"]).include?(dialpad[prev_k])
        end.map do |prev_k|
          {:cost => progress[i-1, j, prev_k][:cost] + dial_distance(dialpad[prev_k], number), :key_press => "r#{number}".to_sym, :previous => [i-1, j, prev_k], :index => i}
        end.min_by {|key_press| key_press[:cost]}
      end
    end
  end

  [progress.goal[:cost], progress.operation_trails.map {|op| op[:key_press]}]
end

class TestDialNumbers < Test::Unit::TestCase
  def test_dial_numbers
    assert_equal([6, [:l4, :r3, :l7]], dial_numbers([4,3,7]))
  end
end