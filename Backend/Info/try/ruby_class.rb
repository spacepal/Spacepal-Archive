class Nn

  def initilize
    p "Nn"
  end

  def self.set a 
    p a
  end

end

class Mm < Nn

  def self.set 
    super 10
  end

end

def ff c, a: :fff, b: 10
  p a
  p b
  p c
end

ff 111, a: 222, b: 333


