require "rbtree"

class TreeMap
  def initialize(&valuation)
    @tree = RBTree.new
    @contents = {}
    @valuation = valuation || Proc.new do |key, value|
      key
    end
  end
  
  def []=(key, value)
    weight = @valuation.call(key, value)
    unless @contents.include? key
      equally_important = (@tree[weight] ||= {})
      equally_important[key] = value
      @contents[key] = [weight, value]
    else
      current_weight = @contents[key].first
      equally_important = @tree[current_weight]
      equally_important.delete(key)
      @tree.delete(current_weight) if equally_important.empty?
      @contents.delete(key)
      self[key] = value
    end
  end

  def [](key)
    (@contents[key] || []).last
  end
  
  def include?(key)
    @contents.include?(key)
  end
  
  def find(&blk)
    @tree.each do |_, equally_important|
      found = equally_important.find(&blk)
      return found if found
    end
    return nil
  end
  
  def inject(memo, &blk)
    @tree.each do |_, equally_important|
      memo = equally_important.inject(memo, &blk)
    end
    memo
  end
  
  def shift
    equally_important = @tree.first && @tree.first.last || {}
    unless equally_important.empty?
      equally_important.shift.tap do |key, value|
        @tree.shift if equally_important.empty?
        @contents.delete(key)
      end
    else
      nil
    end
  end
  
  def empty?
    @tree.empty?
  end
  
  def to_h
    @tree.inject({}) do |memo, (_, hash)|
      memo.merge(hash)
    end
  end
end