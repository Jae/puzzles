require File.join(File.dirname(__FILE__), %w(unweighted_graph))
require File.join(File.dirname(__FILE__), %w(tree_map))

class WeightedGraph
  def self.maximum_flow(graph, from, to)
    paths = []
    while(path = WeightedGraph.shortest_unweighted_path(graph, from, to)) do
      volume = path.each_cons(2).map {|a, b| graph[a][b]}.min
      paths << [volume, path]
      path.each_cons(2) do |a, b|
        graph[a][b] -= volume
        if graph[a][b] == 0
          graph[a].delete(b)
          graph[b].delete(a)
        end
      end
    end
    [paths.inject(0) {|memo, path| memo + path.first}, paths]
  end
  
  def self.shortest_path_tree(graph, root)
    in_tree = {}
    shortest_path_tree = TreeMap.new {|node, (distance, parent)| distance}
    shortest_path_tree[root] = [0, nil]
  
    node = root
    until node.nil? do
      in_tree[node] = true
      graph[node].each do |neighbour, distance|
        unless in_tree[neighbour]
          if !shortest_path_tree[neighbour] || (shortest_path_tree[node][0] + distance < shortest_path_tree[neighbour][0])
            shortest_path_tree[neighbour] = [shortest_path_tree[node][0] + distance, node]
          end
        end
      end
      node = (shortest_path_tree.find {|node, (distance, parent)| !in_tree[node]} || []).first
    end
  
    shortest_path_tree
  end
  
  def self.shortest_unweighted_path(graph, from, to)
    u_graph = Hash[graph.map {|k,v| [k,v.keys]}]

    parents = {}
    UnweightedGraph.breadth_first_traversal(u_graph, from) do |action, args|
      if action == :process_edge
        edge_type, edge_from, edge_to = *args
        if edge_type == :tree_edge
          parents[edge_to] = edge_from
        end
      end
    end
    
    path(parents, from, to)
  end
  
  def self.unweighted_path(graph, from, to)
    u_graph = Hash[graph.map {|k,v| [k,v.keys]}]

    parents = {}
    UnweightedGraph.depth_first_traversal(u_graph, from) do |action, args|
      if action == :process_edge
        edge_type, edge_from, edge_to = *args
        if edge_type == :tree_edge
          parents[edge_to] = edge_from
        end
      end
    end
    
    path(parents, from, to)
  end
  
  private
  def self.path(parents, from, to)
    node = to
    path = [node]
    while (parents[node]) do
      node = parents[node]
      path.unshift(node)
    end
    path if path.first == from
  end
end