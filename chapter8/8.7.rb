require "test/unit"

def distinct_changes_by_coins(amount, coins)
  distinct_changes = 0
  changes = {0 => [{}]}
  while true do
    all_new_amount_bigger_than_amount = true
    changes.keys.dup.each do |change_amount|
      p "change_amount: #{change_amount}"
      coins.each do |coin|
        all_new_amount_bigger_than_amount = false if (change_amount + coin) < amount
        # p [change_amount, coin, amount, all_new_amount_bigger_than_amount]
        distinct_changes += 1 if (change_amount + coin) == amount
        changes[change_amount + coin] ||= changes[change_amount].merge(coin => (changes[change_amount][coin]||0) + 1)
      end
    end
    return distinct_changes if all_new_amount_bigger_than_amount
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
    assert_equal(4, distinct_changes_by_coins(20, [10,6,1]))    
  end
end