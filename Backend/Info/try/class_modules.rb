require_relative 'module.rb'

class Aaa

  include Fff
  include Ddd
  include Sss

  attr_accessor :asds

  def initialize asds
    @asds = asds
  end
end

a = Aaa.new 44
p a.qwe
p (a.methods - Object.methods)