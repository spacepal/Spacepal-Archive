require "rubystats"

mean = 10
stdev = 1.4 #sigma
elements_in_array = 200
array = Array.new

norm = Rubystats::NormalDistribution.new(mean, stdev)

elements_in_array.times do |n|
  array.push norm.rng.round
end

p array.min
p array.max
p (array.sum / elements_in_array).round