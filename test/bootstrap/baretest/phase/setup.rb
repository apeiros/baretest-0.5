require 'baretest/phase/setup'

context = BareTest::Context.new
phase   = BareTest::Phase::Setup.new

assert_same :setup, phase.phase
assert_same false,  phase.returned?
assert_same nil,    phase.return_value
assert_same nil,    phase.raised

phase.call(context)
assert_same :setup, phase.phase
assert_same false,  phase.returned?
assert_same nil,    phase.return_value
assert_same BareTest::Phase::PendingNoCode, phase.raised

phase = BareTest::Phase::Setup.new do :demo_return_value end
phase.call(context)
assert_same true,               phase.returned?
assert_same :demo_return_value, phase.return_value
assert_same nil,                phase.raised

# verify that it modifies the context
modified_context = BareTest::Context.new
phase            = BareTest::Phase::Setup.new do @demo_ivar = :demo_value end
phase.call(modified_context)
assert_same :demo_value, modified_context.instance_variable_get(:@demo_ivar)

exception = RuntimeError.new "demo raise"
phase     = BareTest::Phase::Setup.new do raise exception; :demo_return_value end
phase.call(context)
assert_same false,      phase.returned?
assert_same nil,        phase.return_value
assert_same exception,  phase.raised

exception = Interrupt.new "demo raise"
phase     = BareTest::Phase::Setup.new do raise exception; :demo_return_value end
begin
  phase.call(context)
rescue ::Interrupt
end
assert_same false,      phase.returned?
assert_same nil,        phase.return_value
assert_same exception,  phase.raised

# "wrong" indent to allow CodeSource to work
  block = proc do
    :demo
  end

source = "block = proc do\n  :demo\nend\n"
phase  = BareTest::Phase::Setup.new(&block)
assert_is_a  BareTest::CodeSource, phase.codesource
assert_equal source, phase.codesource.code
