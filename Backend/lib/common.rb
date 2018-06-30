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