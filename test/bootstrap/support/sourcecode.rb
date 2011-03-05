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

  Block1Info = {
    :code => "Block1 = proc do |x|\n  x ** 2\nend",
    :line => 2,
    :file => File.expand_path(__FILE__)
  }
end
