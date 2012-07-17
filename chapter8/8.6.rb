require "test/unit"

def make_changes(amount, coins, changes = {})
  coins.select {|coin| amount >= coin}.map do |coin|
    [amount - coin, changes.merge(coin => (changes[coin] || 0) + 1)]
  end.map do |leftover|
    leftover[0] > 0 ? make_changes(leftover[0], coins, leftover[1]) : leftover[1]
  end.min_by do |change|
    change.values.inject(0) {|sum, i| sum+i}
  end
end

class TestMakeChangeByCoins < Test::Unit::TestCase
  def test_minimum_number_of_coins_used
    assert_equal({6 => 2, 1 => 3}, make_changes(15, [10,6,1]))
  end
end