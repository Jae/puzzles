module SimulatedAnnealing
  
  def simulate(input, expected_cost, max_iteration=100000)
    temp = 1
    number_of_iteration = 0
    solution = make_progress(input)
    
    begin
      10.times do |_|
        break if cost_of(input, solution) <= expected_cost or number_of_iteration > max_iteration
        
        progress = make_progress(input, solution)
        number_of_iteration += 1
        
        if cost_of(input, progress) < cost_of(input, solution)
          solution = progress
        elsif Math.exp((cost_of(input, solution) - cost_of(input, progress)) / temp) > rand
          solution = progress
        else
        end
      end
      temp *= 0.8
    end until cost_of(input, solution) <= expected_cost or number_of_iteration > max_iteration
    
    solution
  end
end