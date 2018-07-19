class Aaa

    JJJ = 5

  def self.d
    self.new.s
  end

  def s
    f
  end

  private

  def f
    p "O-la-la!"
  end

end

Aaa.d