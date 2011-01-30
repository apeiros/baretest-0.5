require 'baretest/phase'

context = BareTest::Context.new
phase   = BareTest::Phase.new(:demo)

assert_same :demo, phase.phase
assert_same false, phase.returned
assert_same nil,   phase.return_value
assert_same nil,   phase.raised

phase.execute(context)
assert_same :demo, phase.phase
assert_same false, phase.returned
assert_same nil,   phase.return_value
assert_same BareTest::Phase::PendingNoCode, phase.raised

phase = BareTest::Phase.new(:demo) do :demo_return_value end
phase.execute(context)
assert_same true,               phase.returned
assert_same :demo_return_value, phase.return_value
assert_same nil,                phase.raised

exception = RuntimeError.new "demo raise"
phase     = BareTest::Phase.new(:demo) do raise exception; :demo_return_value end
phase.execute(context)
assert_same false,      phase.returned
assert_same nil,        phase.return_value
assert_same exception,  phase.raised

exception = Interrupt.new "demo raise"
phase     = BareTest::Phase.new(:demo) do raise exception; :demo_return_value end
begin
  phase.execute(context)
rescue ::Interrupt
end
assert_same false,      phase.returned
assert_same nil,        phase.return_value
assert_same exception,  phase.raised

# "wrong" indent to allow CodeSource to work
  block = proc do
    :demo
  end

source = "block = proc do\n  :demo\nend\n"
phase  = BareTest::Phase.new(:demo, &block)
assert_is_a  BareTest::CodeSource, phase.codesource
assert_equal source, phase.codesource.code
