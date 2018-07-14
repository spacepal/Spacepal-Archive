require_relative 'module.rb'

class Aaa

  include Fff
  include Ddd
  include Sss

end

a = Aaa.new
a.qwe
p (a.methods - Object.methods)