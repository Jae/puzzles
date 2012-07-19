require "test/unit"

def distinct_changes_by_coins(amount, coins)
  changes = {}
  new_changes = {0 => [{}]}
  begin
    new_changes = new_changes.inject({}) do |memo, (change, coins_in_change)|
      coins_in_change.each do |i|
        coins.each do |coin|
          memo[coin+change] ||= []
          memo[coin+change] << i.merge(coin => (i[coin]||0) + 1)
        end
      end if change < amount
      memo
    end
    new_changes.each do |change, coins|
      changes[change] = ((changes[change]||[]) + coins).uniq
    end
  end while new_changes.any? {|(change, _)| change < amount}
  
  changes[amount].size
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