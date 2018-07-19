arr = [nil, "ahsduf", 218, :ahcus, nil, [:hciwu, 131], { jjj: 888 }]
num = 0
v = arr.reduce(num) do |a, b| 
  a = b ? a += 1 : a
end

p v