# Encoding: utf-8

require 'baretest/status'

assert_raises "Expected BareTest::Status.new to raise without arguments" do
  status = BareTest::Status.new
end

assert_raises "Expected BareTest::Status.new to raise with 1 argument" do
  status = BareTest::Status.new(nil)
end

# success
status = BareTest::Status.new(nil, :success)
assert_equal nil, status.entity
assert_equal :success, status.code
assert_equal :cleanup, status.phase
assert_equal nil, status.reason
assert_equal nil, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:success phase=:cleanup>\z/, status.inspect)

# skipped
status = BareTest::Status.new(nil, :skipped, :setup, "Skipreason")
assert_equal nil, status.entity
assert_equal :skipped, status.code
assert_equal :setup, status.phase
assert_equal ["Skipreason"], status.reason
assert_equal nil, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:skipped phase=:setup reason="Skipreason">\z/, status.inspect)

# skipped, long reason
status = BareTest::Status.new(nil, :skipped, :setup, "A very long Skipreason with so many words")
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:skipped phase=:setup reason="A very long Skipreas…">\z/, status.inspect)

# failure
status = BareTest::Status.new(nil, :failure, :verify, "Failurereason")
assert_equal nil, status.entity
assert_equal :failure, status.code
assert_equal :verify, status.phase
assert_equal ["Failurereason"], status.reason
assert_equal nil, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:failure phase=:verify reason="Failurereason">\z/, status.inspect)

# exception
exception = ArgumentError.new("Exceptionmessage")
status    = BareTest::Status.new(nil, :exception, :exercise, nil, exception)
assert_equal nil, status.entity
assert_equal :exception, status.code
assert_equal :exercise, status.phase
assert_equal ["Exceptionmessage"], status.reason
assert_equal exception, status.exception
assert_match(/\A\#<BareTest::Status:0x[\da-f]+ code=:exception phase=:exercise reason="Exceptionmessage" exception="Exceptionmessage">\z/, status.inspect)

