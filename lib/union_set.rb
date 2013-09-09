class UnionSet
  attr_reader :label
  attr_accessor :size
  def initialize(label)
    @label = label
    @size = 1
  end
  
  def ==(another_set)
    self.root.label == another_set.root.label
  end
  
  def merge!(union_set)
    my_root = self.root
    other_root = union_set.root
    unless my_root.label == other_root.label
      if my_root.size < other_root.size
        my_root.parent = other_root
        other_root.size += my_root.size
        other_root
      else
        other_root.parent = my_root
        my_root.size += other_root.size
        my_root
      end
    else
      my_root
    end
  end
  
  def parent=(union_set)
    @parent = union_set
  end
  
  def root
    @parent && @parent.root || self
  end
end