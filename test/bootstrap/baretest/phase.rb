require 'baretest/phase'

context = BareTest::Context.new
phase   = BareTest::Phase.new

assert_same false, phase.returned
assert_same nil,   phase.return_value
assert_same nil,   phase.raised

