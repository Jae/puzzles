require "test/unit"

def min_vertex_cover(tree, parents={}, cover=[], root=tree.keys.first)
  children = tree[root].reject {|child| child == parents[root]}.each {|child| parents[child] = root}
  children.reject{|child| tree[child].size == 1}.each do |sub_root|
    min_vertex_cover(tree, parents, cover, sub_root)
  end
  
  unless children.all? {|child| cover.include? child}
    cover << root
  end
  cover.sort
end

def min_vertex_cover_by_degree_of_node(tree, parents={}, cover=[], root=tree.keys.first)
  children = tree[root].reject {|child| child == parents[root]}.each {|child| parents[child] = root}
  children.reject{|child| tree[child].size == 1}.each do |sub_root|
    min_vertex_cover_by_degree_of_node(tree, parents, cover, sub_root)
  end
  
  unless children.all? {|child| cover.include? child}
    if tree[root].size > children.inject(0){|weight, child| weight + tree[child].size}
      children.each {|child| cover << child}
    else
      cover << root
    end
  end
  cover.sort
end

class TestVertexCover < Test::Unit::TestCase
  def test_min_vertex_cover
    assert_equal([:B,:C,:E,:J], min_vertex_cover({
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
  
  def test_min_vertex_cover_by_degree_of_node
    assert_equal([:B, :C, :F, :G, :H, :L, :M, :N], min_vertex_cover_by_degree_of_node({
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