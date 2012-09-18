require "test/unit"

def evaluate_tree(tree)
  left = tree[1].size == 1 ? tree[1].first : evaluate_tree(tree[1]).to_f
  right = tree[2].size == 1 ? tree[2].first : evaluate_tree(tree[2]).to_f
  left.send(tree[0], right)
end

class TestArithmeticExpressionTree < Test::Unit::TestCase
  def test_evaluate_arithmetic_expression
    assert_equal(16.4, evaluate_tree([:+,[:/,[:*,[3],[4]],[5]],[:+,[2],[:*,[3],[4]]]]))
  end
end