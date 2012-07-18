require "test/unit"

def distinct_changes_by_coins(amount, coins)
  distinct_changes = 0
  new_amounts = [0]
  begin
    new_amounts = new_amounts.product(coins).inject([]) do |memo, (new_amount,coin)|
      memo << new_amount + coin
      memo
    end.uniq
    distinct_changes += new_amounts.select {|new_amount| new_amount == amount}.size

    new_amounts = new_amounts.uniq
  end while new_amounts.any? {|new_amount| new_amount < amount}
  distinct_changes 
end

class TestNumberOfDistinctChangeByCoins < Test::Unit::TestCase
  def test_distinct_changes_by_coins
    assert_equal(1, distinct_changes_by_coins(5, [10,6,1]))
    assert_equal(2, distinct_changes_by_coins(6, [10,6,1]))
    assert_equal(2, distinct_changes_by_coins(7, [10,6,1]))
    assert_equal(2, distinct_changes_by_coins(8, [10,6,1]))
    assert_equal(2, distinct_changes_by_coins(9, [10,6,1]))
    assert_equal(3, distinct_changes_by_coins(10, [10,6,1]))
    assert_equal(4, distinct_changes_by_coins(12, [10,6,1]))
    assert_equal(7, distinct_changes_by_coins(20, [10,6,1]))
  end
end