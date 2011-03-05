require 'baretest/test'

# Setup becomes executed
context = BareTest::Context.new
test = BareTest::Test.new
test.define_exercise do @exercise = 1 end
test.call(context) do end
assert_same 1, context.instance_variable_get(:@setup)

# Teardown becomes executed
context = BareTest::Context.new
testbed = BareTest::TestBed.new
testbed.define_teardown do @teardown = 1 end
testbed.call(context) do end
assert_same 1, context.instance_variable_get(:@teardown)

# Multiple setups become executed
context = BareTest::Context.new
testbed = BareTest::TestBed.new
testbed.define_setup do @setup1 = 1 end
testbed.define_setup do @setup2 = 2 end
testbed.define_setup do @setup3 = 3 end
testbed.call(context) do end
assert_same 1, context.instance_variable_get(:@setup1)
assert_same 2, context.instance_variable_get(:@setup2)
assert_same 3, context.instance_variable_get(:@setup3)

# Multiple teardowns become executed
context = BareTest::Context.new
testbed = BareTest::TestBed.new
testbed.define_teardown do @teardown1 = 1 end
testbed.define_teardown do @teardown2 = 2 end
testbed.define_teardown do @teardown3 = 3 end
testbed.call(context) do end
assert_same 1, context.instance_variable_get(:@teardown1)
assert_same 2, context.instance_variable_get(:@teardown2)
assert_same 3, context.instance_variable_get(:@teardown3)

# Block is executed
context = BareTest::Context.new
testbed = BareTest::TestBed.new
x       = :untouched
block   = proc do x = :touched end
assert_same :untouched, x
testbed.call(context, &block)
assert_same :touched, x

# Order is: setup in definition order, block, teardown in definition order
x       = 0
y       = 0
context = BareTest::Context.new
testbed = BareTest::TestBed.new
testbed.define_setup do @setup1 = (x+=1) end
testbed.define_setup do @setup2 = (x+=1) end
testbed.define_teardown do @teardown1 = (x+=1) end
testbed.define_teardown do @teardown2 = (x+=1) end
testbed.call(context) do y = (x+=1) end
assert_same 1, context.instance_variable_get(:@setup1)
assert_same 2, context.instance_variable_get(:@setup2)
assert_same 3, y
assert_same 4, context.instance_variable_get(:@teardown1)
assert_same 5, context.instance_variable_get(:@teardown2)
