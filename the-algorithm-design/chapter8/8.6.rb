require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib dynamic_programming))

def dynamic_make_min_coins_changes(amount, coins)
  progress = DynamicProgress.new(amount) do |current_goal, operation|
    if operation[:changes].map {|coin, change| coin * change}.reduce(&:+) == amount
      current_goal && operation[:changes].values.reduce(&:+) < current_goal[:changes].values.reduce(&:+) && current_goal || operation
    else
      current_goal
    end
  end
  
  progress.each do |sub_amount| #progress[i] = min coin changes for the amount i if possible
    if sub_amount == 0
      {:changes => Hash[coins.map {|coin| [coin, 0]}]}
    else
      coins.map {|coin| [coin, sub_amount - coin]}.select do |coin, previous_sub_amount|
        progress[previous_sub_amount]
      end.map do |coin, previous_sub_amount|
        {:changes => progress[previous_sub_amount][:changes].merge(coin => progress[previous_sub_amount][:changes][coin] + 1)}
      end.min_by {|operation| operation[:changes].values.reduce(&:+)}
    end
  end
  
  progress.goal[:changes].reject{|k,v| v == 0}
end

class TestMakeChangeByCoins < Test::Unit::TestCase
  def test_dynamic_make_min_coins_changes
    assert_equal({6 => 2, 1 => 3}, dynamic_make_min_coins_changes(15, [10,6,1]))
    assert_equal({10=>15}, dynamic_make_min_coins_changes(150, [10,6,1]))
  end
end