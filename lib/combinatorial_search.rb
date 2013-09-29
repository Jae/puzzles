module CombinatorialSearch
  def duplicate_combination?(progress)
    (@progresses ||= {})[progress.size] ||= {}

    @progresses[progress.size].include?(progress).tap do |duplicate_combination|
      @progresses[progress.size][progress] = progress unless duplicate_combination
    end
  end
  
  def backtrack(input, find_all_solutions=true, progress=nil, solutions=[])
    if progress && is_solution?(input, progress)
      solutions << progress
    else
      candidates(input, progress, solutions).each do |candidate|
        backtrack(input, find_all_solutions, candidate, solutions) unless duplicate_combination?(candidate)
        return solutions unless find_all_solutions || solutions.empty?
      end
    end
    solutions
  end
end