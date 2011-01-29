module Support
  Block1 = proc do |x|
    x ** 2
  end

  def self.create_block(&block)
    @block = block
  end

  def self.block
    @block
  end

  create_block do |x|
    x ** 3
  end
end
