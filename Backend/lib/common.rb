require 'rainbow'

class Array

  def pluck *args
    self.map do |el|
      a = {}
      args.each do |arg|
        a[arg] = el.instance_variable_get("@" + arg.to_s)
      end
      a
    end
  end 
  def pluck_arr symb
    if self[0].class == Array or self[0].class == Hash
      self.map { |el| el[symb.to_sym] }
    else
      self.map { |el| el.send(symb.to_sym)}
    end
  end
  def ids
    self.pluck_arr :id
  end

end

class String 

  def color color
    s = Rainbow(self)
    s.send(color.to_sym)
  end

  def bg color
    s = Rainbow(self).bg(color.to_sym)
  end

  def out
    puts self
  end

  def print_
    print self
  end

  def pp_
    pp self
  end

  def to_bool
    return true if self == "true"
    return false
  end

  private 

end

class FalseClass

  def to_bool 
    self
  end

end

class TrueClass

  def to_bool
    self
  end

end

class NilClass

  def to_bool
    nil
  end

end