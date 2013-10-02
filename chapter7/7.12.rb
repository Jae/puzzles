require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))
require File.join(File.dirname(__FILE__), %w(.. lib simulated_annealing))

class MaximumEdgeDAG
  include CombinatorialSearch
  
  def self.edges_in_conflicting_order(graph, topological_order)
    graph.map do |from, neighbours|
      neighbours.select do |to|
        topological_order.include?(from) && topological_order.include?(to) && topological_order.index(from) > topological_order.index(to) ||
        !topological_order.include?(from) && topological_order.include?(to)
      end.size
    end.reduce(&:+)
  end
  
  def is_solution?(input, progress)
    (input.keys.size == progress.size).tap do |solution|
      if solution
        MaximumEdgeDAG.edges_in_conflicting_order(input, progress).tap do |edges_in_conflicting_order|
          if !@min_edges_in_conflicting_order || @min_edges_in_conflicting_order > edges_in_conflicting_order
            @min_edges_in_conflicting_order = edges_in_conflicting_order
          end
        end
      end
    end
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= []
    
    (input.keys - progress).sort_by do |outbound| 
      input[outbound].size - input.select{|inbound| input[inbound].include? outbound}.size
    end.reverse.map do |candidate|
      progress + [candidate]
    end.reject do |candidate|
      @min_edges_in_conflicting_order && (MaximumEdgeDAG.edges_in_conflicting_order(input, candidate)) >= @min_edges_in_conflicting_order
    end
  end
  
  def self.find(input)
    solutions = new.backtrack(input)
    topological_order = solutions.min_by {|solution| edges_in_conflicting_order(input, solution)}
    Hash[input.map do |from, neighbours|
      [from, neighbours.reject do |to|
        topological_order.index(from) > topological_order.index(to)
      end]
    end]
  end
end

class MaximumEdgeDAGBySimulatedAnnealing
  include SimulatedAnnealing
  
  def cost_of(input, solution)
    input.map do |from, neighbours|
      neighbours.select do |to|
        solution.index(from) > solution.index(to)
      end.size
    end.reduce(&:+)
  end
  
  def make_progress(input, solution=nil)
    unless solution
      input.keys.shuffle
    else
      x = solution.sample
      y = (solution - [x]).sample
      xi = solution.index(x)
      yi = solution.index(y)
      if xi < yi
        solution[0...xi] + [y] + solution[xi+1...yi] + [x] + solution[yi+1..-1]
      else
        solution[0...yi] + [x] + solution[yi+1...xi] + [y] + solution[xi+1..-1]
      end
    end
  end
  
  def self.find(input, expected_cost)
    topological_order = new.simulate(input, expected_cost)
    Hash[input.map do |from, neighbours|
      [from, neighbours.reject do |to|
        topological_order.index(from) > topological_order.index(to)
      end]
    end]
  end
end

class TestMinimumFeedbackEdge < Test::Unit::TestCase
  def input
    {
      A: [:B],
      B: [:C, :N],
      C: [:D],
      D: [:E],
      E: [:F, :I],
      F: [:G],
      G: [:H],
      H: [:D],
      I: [:J],
      J: [:A, :K],
      K: [:L],
      L: [:M],
      M: [:J],
      N: [:O],
      O: [:P],
      P: [:B]
    }
  end
  
  def test_minimum_feedback_edge
    solution = MaximumEdgeDAG.find(input)
    edges = input.map{|k,v| v.map {|n| [k,n]}}.flatten(1)
    dag_edges = solution.map{|k,v| v.map {|n| [k,n]}}.flatten(1)
    
    assert_equal(3, (edges - dag_edges).size)
  end
  
  def test_minimum_feedback_edge_via_simulated_annealing
    solution = MaximumEdgeDAGBySimulatedAnnealing.find(input, 3)
    edges = input.map{|k,v| v.map {|n| [k,n]}}.flatten(1)
    dag_edges = solution.map{|k,v| v.map {|n| [k,n]}}.flatten(1)
    
    assert_equal(3, (edges - dag_edges).size)
  end
end