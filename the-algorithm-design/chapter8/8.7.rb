require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def distinct_changes_by_coins(amount, coins)
  progress = DynamicProgress.new(amount) do |current_goal, operation|
    operation.any? {|e| e[:changes].map {|coin, change| coin * change}.reduce(&:+) == amount} && operation || current_goal
  end
  
  progress.each do |sub_amount| #progress[i] = coin changes for the amount i if possible
    if sub_amount == 0
      [{:changes => Hash[coins.map {|coin| [coin, 0]}]}]
    else
      coins.map {|coin| [coin, sub_amount - coin]}.select do |coin, previous_sub_amount|
        progress[previous_sub_amount]
      end.map do |coin, previous_sub_amount|
        progress[previous_sub_amount].map do |e|
          {:changes => e[:changes].merge(coin => e[:changes][coin] + 1)}
        end
      end.flatten(1).uniq {|e| e[:changes]}
    end
  end

  progress.goal.size
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