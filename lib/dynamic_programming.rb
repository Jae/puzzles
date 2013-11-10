class DynamicProgress
  attr_reader :goal
  
  def initialize(*dimensions, &goal_detection)
    @dimensions = dimensions.map {|dimension| dimension + 1}
    @goal_detection, @goal = goal_detection, nil
    @progress = multidimensional_array(@dimensions) {nil}
  end
  
  def each(&blk)
    indexes_first, *indexes_rest= @dimensions.map {|dimension| dimension.times.to_a}
    indexes_first.product(*indexes_rest).each do |indexes|
      yield(*indexes).tap do |operation|
        if operation
          @goal = @goal_detection ? @goal_detection.call(@goal, operation) : operation
          self[*indexes[0...-1]][indexes[-1]] = operation
        end
      end
    end
  end
  
  def [](*indexes)
    indexes.inject(@progress) {|memo, index| memo[index]} if indexes.all? {|index| index >= 0}
  end
  
  def operation_trails
    operation_trails_to(@goal) if @goal
  end
  
  private
  def multidimensional_array(dimensions, &blk)
    Array.new(dimensions.first) { dimensions.size > 1 && multidimensional_array(dimensions[1..-1], &blk) || blk.call }
  end
  
  def operation_trails_to(operation)
    operations = [operation]
    while operation[:previous] do
      operation = self[*operation[:previous]]
      operations.unshift(operation)
    end
    operations
  end
end