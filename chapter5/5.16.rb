require "test/unit"

def max_independent_set(tree, parents={}, set=[], root=tree.keys.first)
  children = tree[root].reject {|child| child == parents[root]}.each {|child| parents[child] = root}
  children.reject{|child| tree[child].size == 1}.each do |sub_root|
    max_independent_set(tree, parents, set, sub_root)
  end
  
  (children + [root]).each do |candidate|
    set << candidate unless set.include? candidate or tree[candidate].any? {|neighbour| set.include? neighbour}
  end
  set.sort
end

def max_independent_set_by_degree_of_node(tree, parents={}, set=[], root=tree.keys.first)
  children = tree[root].reject {|child| child == parents[root]}.each {|child| parents[child] = root}
  children.reject{|child| tree[child].size == 1}.each do |sub_root|
    max_independent_set_by_degree_of_node(tree, parents, set, sub_root)
  end
  
  ([root] + children).each do |candidate|
    set << candidate unless set.include? candidate or tree[candidate].any? {|neighbour| set.include? neighbour}
  end
  set.sort
end

class TestMaxIndependentSet < Test::Unit::TestCase
  def test_max_independent_set
    assert_equal([:A, :D, :F, :G, :H, :I, :K, :L, :M, :N], max_independent_set({
      A:[:B,:C],
      B:[:A,:D,:E],
      C:[:A,:I,:J,:K],
      D:[:B],
      E:[:B,:F,:G,:H],
      F:[:E],
      G:[:E],
      H:[:E],
      I:[:C],
      J:[:C,:L,:M,:N],
      K:[:C],
      L:[:J],
      M:[:J],
      N:[:J]
    }))
  end
  
  def test_max_independent_set_by_degree_of_node
    assert_equal([:A, :D, :E, :I, :J, :K], max_independent_set_by_degree_of_node({
      A:[:B,:C],
      B:[:A,:D,:E],
      C:[:A,:I,:J,:K],
      D:[:B],
      E:[:B,:F,:G,:H],
      F:[:E],
      G:[:E],
      H:[:E],
      I:[:C],
      J:[:C,:L,:M,:N],
      K:[:C],
      L:[:J],
      M:[:J],
      N:[:J]
    }))
  end
end