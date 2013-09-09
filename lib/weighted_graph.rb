require File.join(File.dirname(__FILE__), %w(unweighted_graph))

class WeightedGraph
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