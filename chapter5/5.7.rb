require "test/unit"

def tree_from_pre_and_in_order(pre_traversal, in_traversal)
  root = pre_traversal.first
  left = in_traversal[0...in_traversal.index(root)]
  right = in_traversal[in_traversal.index(root)+1..-1]
  left_tree = tree_from_pre_and_in_order(pre_traversal[1..-1] - right, left) if left.size > 1
  right_tree = tree_from_pre_and_in_order(pre_traversal[1..-1] - left, right) if right.size > 1
  {root => [left_tree || left.first, right_tree || right.first]}
end

def tree_from_pre_and_post_order(pre_traversal, post_traversal)
  forest = []
  root = pre_traversal.first
  pre_rest = pre_traversal - [root]
  post_rest = post_traversal - [root]
  
  pre_rest.each_index do |index|
    pre_left = pre_rest[0..index]
    pre_right = pre_rest[index+1..-1]
    post_left = post_rest[0..index]
    post_right = post_rest[index+1..-1]

    if (pre_left - post_left).empty? and (post_left - pre_left).empty? and pre_left.first == post_left.last and pre_right.first == post_right.last
      
      left_forest = tree_from_pre_and_post_order(pre_left, post_left) if pre_left.size > 1
      right_forest = tree_from_pre_and_post_order(pre_right, post_right) if pre_right.size > 1
      (left_forest || [pre_left.first]).each do |left_tree|
        (right_forest || [pre_right.first]).each do |right_tree|
          forest << {root => [left_tree, right_tree]}
        end
      end
    end
  end
  
  forest
end

class TestTreeReconstruction < Test::Unit::TestCase
  def test_tree_reconstruction_from_pre_and_in_order_traversal
    assert_equal({:F=>[
      {:B=>[
        :A, {:D=>[:C, :E]}
      ]}, 
      {:G=>[
        nil, {:I=>[:H, nil]}
      ]}
    ]}, tree_from_pre_and_in_order([:F, :B, :A, :D, :C, :E, :G, :I, :H], [:A, :B, :C, :D, :E, :F, :G, :H, :I]))
  end
  
  def test_tree_reconstruction_from_pre_and_post_order_traversal
    assert_block("tree reconstruction is not always possible just from pre and post order traversal") do
      tree = {:F=>[
        {:B=>[
          :A, {:D=>[:C, :E]}
        ]}, 
        {:G=>[
          {:I=>[:H, nil]}, nil
        ]}
      ]}
      tree_from_pre_and_post_order([:F, :B, :A, :D, :C, :E, :G, :I, :H], [:A, :C, :E, :D, :B, :H, :I, :G, :F]).include? tree
    end
  end
end