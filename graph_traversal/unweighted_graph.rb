class UnweightedGraph
  def self.breadth_first_traversal(graph, root=graph.keys.first, &blk)
    discovered = [root]
    to_process = [root]
    until to_process.empty? do
      node = to_process.shift
      blk.call(:process_vertex_early, node) if blk
      graph[node].each do |child|
        blk.call(:process_edge, [bft_edge_type(node, child, discovered), node, child]) if blk
        unless discovered.include? child
          discovered << child
          to_process << child
        end
      end
      blk.call(:process_vertex, node) if blk
    end
  end
  
  def self.depth_first_traversal(graph, root=graph.keys.first, visited=[], processed=[], &blk)
    visited << root
    blk.call(:process_vertex_early, root) if blk
    graph[root].each do |sub_root|
      blk.call(:process_edge, [dft_edge_type(root, sub_root, visited, processed), root, sub_root]) if blk
      unless visited.include? sub_root
        depth_first_traversal(graph, sub_root, visited, processed, &blk)
      end
    end
    processed << root
    blk.call(:process_vertex, root) if blk
  end

  private
  def self.bft_edge_type(from, to, discovered)
    if discovered.include? to
      :cross_edge
    else
      :tree_edge
    end
  end
  
  def self.dft_edge_type(from, to, visited, processed)
    if visited.include? to
      if processed.include? to
        if visited.index(from) < visited.index(to)
          :forward_edge
        else
          :cross_edge
        end
      else
        :back_edge
      end
    else
      :tree_edge
    end
  end
end