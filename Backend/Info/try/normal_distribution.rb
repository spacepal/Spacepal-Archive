require "rubystats"

mean = 9
stdev = 1.3 #sigma
elements_in_array = 200
array = Array.new

norm = Rubystats::NormalDistribution.new(mean, stdev)

elements_in_array.times do |n|
  n = norm.rng
  n = n <= 9 ? n * 0.85 : n * 1.1
  array.push n.round 
end

pp array
p array.min
p array.max
p (array.sum / elements_in_array).round