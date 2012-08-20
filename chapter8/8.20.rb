require "test/unit"

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
  dialed = Array.new(numbers.size) {Array.new(12) {Array.new(12)}} #dialed[i][l][r] = d where d is minimum distance fingers travelled to dial numbers[0..i] so that left and right fingers ended up at l and r positions
  
  12.times do |l|
    12.times do |r|
      number = numbers.first
      if [dialpad[l], dialpad[r]] == [number, "#"]
        dialed[0][l][r] = [dial_distance("*", number), ["l#{number}".to_sym]] 
      elsif [dialpad[l], dialpad[r]] == ["*", number]
        dialed[0][l][r] = [dial_distance("#", number), ["r#{number}".to_sym]]
      else
        dialed[0][l][r] = [Float::INFINITY, []]
      end
    end
  end
  
  (1...numbers.size).each do |i|
    number = numbers[i]
    12.times do |l|
      12.times do |r|
        if dialpad[l] == number
          dialed[i][l][r] = 12.times.map do |pre_l|
            [dialed[i-1][pre_l][r][0] + dial_distance(dialpad[pre_l], number), dialed[i-1][pre_l][r][1] + ["l#{number}".to_sym]]
          end.min_by {|(distance,_)| distance}
        elsif dialpad[r] == number
          dialed[i][l][r] = 12.times.map do |pre_r|
            [dialed[i-1][l][pre_r][0] + dial_distance(dialpad[pre_r], number), dialed[i-1][l][pre_r][1] + ["r#{number}".to_sym]]
          end.min_by {|(distance,_)| distance}
        else
          dialed[i][l][r] = [Float::INFINITY, []]
        end
      end
    end
  end
  
  min_dial = [Float::INFINITY, []]
  12.times do |l|
    12.times do |r|
      min_dial = dialed.last[l][r] if dialed.last[l][r][0] < min_dial[0]
    end
  end
  min_dial
end

class TestDialNumbers < Test::Unit::TestCase
  def test_dial_numbers
    assert_equal([6, [:l4, :r3, :l7]], dial_numbers([4,3,7]))
  end
end