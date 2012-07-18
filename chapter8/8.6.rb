require "test/unit"

def recurisve_make_changes(amount, coins, changes = {})
  coins.select {|coin| amount >= coin}.map do |coin|
    [amount - coin, changes.merge(coin => (changes[coin] || 0) + 1)]
  end.map do |leftover|
    leftover[0] > 0 ? recurisve_make_changes(leftover[0], coins, leftover[1]) : leftover[1]
  end.min_by do |change|
    change.values.inject(0) {|sum, i| sum+i}
  end
end

def dynamic_make_changes(amount, coins)
  changes = {0 => {}}
  while changes[amount].nil?
    changes.keys.dup.each do |change_amount|
      coins.each do |coin|
        changes[change_amount + coin] = changes[change_amount].merge(coin => (changes[change_amount][coin]||0) + 1)
      end
    end
  end
  changes[amount]
end

class TestMakeChangeByCoins < Test::Unit::TestCase
  def test_recurisve_make_changes
    assert_equal({6 => 2, 1 => 3}, recurisve_make_changes(15, [10,6,1]))
  end
  
  def test_dynamic_make_changes
    assert_equal({10=>15}, dynamic_make_changes(150, [10,6,1]))
  end
end