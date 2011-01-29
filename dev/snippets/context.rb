class Context < BasicObject
  def self.const_missing(name)
    ::Object.const_defined?(name) ? ::Object.const_get(name) : super
  end
end

x = Context.new
r = x.instance_eval do
  Array.new
end

p r
p Object.instance_method(:methods).bind(x).call.sort