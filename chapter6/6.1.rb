require "test/unit"
require File.join(File.dirname(__FILE__), %w(.. lib weighted_graph))
require File.join(File.dirname(__FILE__), %w(.. lib tree_map))
require File.join(File.dirname(__FILE__), %w(.. lib union_set))

def minimum_spanning_tree_by_prim(graph, start)
  in_tree = {}
  shortest_distance_from_start = TreeMap.new {|node, (distance, parent)| distance}
  shortest_distance_from_start[start] = [0, nil]
  
  node = start
  until node.nil? do
    in_tree[node] = true
    graph[node].each do |neighbour, distance|
      unless in_tree[neighbour]
        if !shortest_distance_from_start[neighbour] || (distance < shortest_distance_from_start[neighbour][0])
          shortest_distance_from_start[neighbour] = [distance, node]
        end
      end
    end
    node = (shortest_distance_from_start.find {|node, (distance, parent)| !in_tree[node]} || []).first
  end
  
  shortest_distance_from_start.inject({}) do |memo, (node, (distance, parent))|
    if parent
      memo[node] ||= {}; memo[node][parent] = graph[node][parent]
      memo[parent] ||= {}; memo[parent][node] = graph[parent][node]
    end
    memo
  end
end

def minimum_spanning_tree_by_kruskals(graph)
  shortest_path = TreeMap.new {|(from, to), distance| distance}
  graph.each do |from, destinations|
    destinations.each do |to, distance|
      shortest_path[[from, to]] = distance
    end
  end
  
  in_group = Hash[graph.keys.map {|key| [key, UnionSet.new(key)]}]

  spanning_tree = TreeMap.new
  until shortest_path.empty? do
    (from, to), distance = shortest_path.shift
    unless in_group[from] == in_group[to]
      in_group[to].merge!(in_group[from])
      
      (spanning_tree[from] ||= {})[to] = distance
      (spanning_tree[to] ||= {})[from] = distance
    end
  end
  
  spanning_tree.to_h
end

def shortest_path_by_dijkstra(graph, from, to)
  shortest_path_tree = WeightedGraph.shortest_path_tree(graph, from)
  
  path = [to]
  while (shortest_path_tree[to][1] != from) do
    to = shortest_path_tree[to][1]
    path << to
  end
  path << from
  path.reverse
end

def graph
  {
    A: {B:6, D:4, I:9},
    B: {A:6, C:3, D:3, E:1},
    C: {B:3, E:2, F:2},
    D: {A:4, B:3, E:4, G:6},
    E: {B:1, C:2, D:4, F:8, G:6, H:7},
    F: {C:2, E:8, H:11},
    G: {D:6, E:6, H:3, I:2, J:2},
    H: {E:7, F:11, G:3, J:4},
    I: {A:9, G:2, J:1},
    J: {G:2, H:4, I:1}
  }
end

class MinimumSpanningTree < Test::Unit::TestCase
  def test_prims_algorithm
    assert_equal({
      E: {B: 1, C: 2},
      B: {E: 1, D: 3},
      J: {I: 1},
      I: {J: 1, G: 2},
      C: {E: 2, F: 2},
      F: {C: 2},
      G: {I: 2, H: 3, D: 6},
      D: {B: 3, A: 4, G: 6},
      H: {G: 3},
      A: {D: 4}
    }, minimum_spanning_tree_by_prim(graph, :A))
  end
  
  def test_kruskals_algorithm
    assert_equal({
     A: {D:4},
     B: {E:1, D:3},
     C: {E:2, F:2},
     D: {B:3, A:4, G:6},
     E: {B:1, C:2},
     F: {C:2},
     G: {I:2, H:3, D:6},
     H: {G:3},
     I: {J:1, G:2},
     J: {I:1}
    }, minimum_spanning_tree_by_kruskals(graph))
  end
end

class ShortestPathTree < Test::Unit::TestCase
  def test_dijkstra_algorithm
    assert_equal([:A, :D, :G, :H], shortest_path_by_dijkstra(graph, :A, :H))
  end
end

class MaximumFlow < Test::Unit::TestCase
  def test_maximum_flow
    assert_equal([7, [
      [1, [:A, :I, :J]], 
      [2, [:A, :D, :G, :J]], 
      [1, [:A, :B, :E, :H, :J]], 
      [2, [:A, :D, :E, :H, :J]], 
      [1, [:A, :I, :G, :H, :J]]]], WeightedGraph.maximum_flow(graph, :A, :J))
  end
end