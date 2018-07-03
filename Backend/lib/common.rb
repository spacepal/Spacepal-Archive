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

end

class String 

  def color color
    s = Rainbow(self)
    eval("s." + color.to_s)
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

  private 

end