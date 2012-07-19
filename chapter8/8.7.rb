require "test/unit"
  
def distinct_changes_by_coins(amount, coins)
  coins.select {|coin| amount >= coin}.inject(0) do |sum, coin|
    if amount - coin == 0
      sum += 1 
    else
      sum += distinct_changes_by_coins(amount-coin, coins.select{|rest| rest <= coin})
    end
  end
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