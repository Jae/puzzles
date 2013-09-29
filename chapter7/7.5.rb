require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib combinatorial_search))

class IsomorphicSubgraph
  include CombinatorialSearch
  
  def is_solution?(input, progress)
    graph_one, graph_two = input
    graph_one.size == progress.size && progress.all? do |k,v|
      graph_one[k].all? do |graph_one_neighbour| 
        graph_two[v].include? progress[graph_one_neighbour]
      end
    end
  end
  
  def candidates(input, progress, solutions=[])
    progress ||= {}
    graph_one, graph_two = input
    
    unless progress.empty?
      last_candidate = progress.to_a.last
      (graph_one[last_candidate.first].reject {|graph_one_neighbour| progress.keys.include? graph_one_neighbour}).product(
      graph_two[last_candidate.last].reject {|graph_two_neighbour| progress.values.include? graph_two_neighbour})
    else
      (graph_one.keys - progress.keys).product(graph_two.keys - progress.values)
    end.select do |k, v|
      graph_one[k].size <= graph_two[v].size && graph_one[k].select do |graph_one_neighbour| 
        progress.keys.include? graph_one_neighbour
      end.all? do |graph_one_neighbour|
        graph_two[progress[graph_one_neighbour]].include? v
      end
    end.map do |k, v|
      progress.merge(k => v)
    end
  end
  
  def self.match(graph_one, graph_two)
    new.backtrack([graph_one, graph_two]).map do |mappings|
      Hash[mappings]
    end
  end
end

class TestIsomorphicSubgraph < Test::Unit::TestCase
  def test_isomorphic_subgraph
    mappings = IsomorphicSubgraph.match({
      1 => [2, 3, 5],
      2 => [1, 4, 6],
      3 => [1, 8, 9],
      4 => [2, 7, 8],
      5 => [1, 7, 10],
      6 => [2, 9, 10],
      7 => [4, 5, 9],
      8 => [3, 4, 10],
      9 => [3, 6, 7],
      10 => [5, 6, 8]
    }, {
      A: [:B, :E, :G],
      B: [:A, :C, :H, :K],
      C: [:B, :D, :I],
      D: [:C, :E, :J],
      E: [:A, :D, :F],
      F: [:E, :H, :I],
      G: [:A, :I, :J],
      H: [:B, :F, :J, :K],
      I: [:C, :F, :G],
      J: [:D, :G, :H],
      K: [:H, :L, :B],
      L: [:K]
    })
    assert(mappings.include?(
      1 => :A, 
      2 => :B,
      3 => :G,
      4 => :C,
      5 => :E,
      6 => :H,
      7 => :D,
      8 => :I,
      9 => :J,
      10 => :F
    ))
  end
end