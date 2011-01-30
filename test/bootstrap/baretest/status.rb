# Encoding: utf-8

require 'baretest/status'

assert_raises "Expected BareTest::Status.new to raise without arguments" do
  status = BareTest::Status.new
end

assert_raises "Expected BareTest::Status.new to raise with 1 argument" do
  status = BareTest::Status.new(:success)
end

# success
status = BareTest::Status.new(:success, :cleanup)
assert_equal :success, status.code
assert_same  true, status.success?
assert_same  false, status.pending?
assert_same  false, status.failure?
assert_same  false, status.exception?
assert_equal :cleanup, status.phase
assert_equal nil, status.reason
assert_equal nil, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:success phase=:cleanup>\z/, status.inspect)

# pending
status = BareTest::Status.new(:pending, :setup, "Skipreason")
assert_equal :pending, status.code
assert_same  false, status.success?
assert_same  true, status.pending?
assert_same  false, status.failure?
assert_same  false, status.exception?
assert_equal :setup, status.phase
assert_equal ["Skipreason"], status.reason
assert_equal nil, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:pending phase=:setup reason="Skipreason">\z/, status.inspect)

# pending, long reason
status = BareTest::Status.new(:pending, :setup, "A very long Skipreason with so many words")
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:pending phase=:setup reason="A very long Skipreas…">\z/, status.inspect)

# failure
status = BareTest::Status.new(:failure, :verification, "Failurereason")
assert_equal :failure, status.code
assert_same  false, status.success?
assert_same  false, status.pending?
assert_same  true, status.failure?
assert_same  false, status.exception?
assert_equal :verification, status.phase
assert_equal ["Failurereason"], status.reason
assert_equal nil, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:failure phase=:verification reason="Failurereason">\z/, status.inspect)

# exception
exception = ArgumentError.new("Exceptionmessage")
status    = BareTest::Status.new(:exception, :exercise, nil, exception)
assert_equal :exception, status.code
assert_same  false, status.success?
assert_same  false, status.pending?
assert_same  false, status.failure?
assert_same  true, status.exception?
assert_equal :exercise, status.phase
assert_equal ["Exceptionmessage"], status.reason
assert_equal exception, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:exception phase=:exercise reason="Exceptionmessage" exception="Exceptionmessage">\z/, status.inspect)

