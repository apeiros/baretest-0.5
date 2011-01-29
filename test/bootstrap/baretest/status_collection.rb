require 'baretest/status_collection'

raise "Missing StatusCollection" unless defined? BareTest::StatusCollection

collection = BareTest::StatusCollection.new
assert_equal nil, collection.code

collection << BareTest::Status.new(nil, :success)
assert_equal :success, collection.code
collection << BareTest::Status.new(nil, :skipped)
assert_equal :skipped, collection.code
collection << BareTest::Status.new(nil, :failure)
collection << BareTest::Status.new(nil, :success)
assert_equal :failure, collection.code
collection << BareTest::Status.new(nil, :exception)
assert_equal :exception, collection.code

assert_equal [2], collection.values_at(:success)

second_collection = BareTest::StatusCollection.new
second_collection << BareTest::Status.new(nil, :failure)
second_collection << BareTest::Status.new(nil, :success)

collection.update second_collection
assert_equal [3, 1, 2, 1], collection.values_at(:success, :skipped, :failure, :exception)
