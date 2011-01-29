require 'baretest/status_collection'

# An empty collection has no status code
collection = BareTest::StatusCollection.new
assert_equal nil, collection.code

# A collection with only a success has the code :success
collection << BareTest::Status.new(nil, :success)
assert_equal :success, collection.code

# A collection with a success and a skipped has the code :skipped
collection << BareTest::Status.new(nil, :skipped)
assert_equal :skipped, collection.code

# A collection with a success, a skipped and a failure has the code :failure
collection << BareTest::Status.new(nil, :failure)
assert_equal :failure, collection.code

# Adding another success will not change the code to be :failure
collection << BareTest::Status.new(nil, :success)
assert_equal :failure, collection.code

# A collection with a success, a skipped, a failure and an exception has the
# code :exception
collection << BareTest::Status.new(nil, :exception)
assert_equal :exception, collection.code

# Verify the counts
assert_equal [2], collection.values_at(:success)

# Verify mergin two collections
second_collection = BareTest::StatusCollection.new
second_collection << BareTest::Status.new(nil, :failure)
second_collection << BareTest::Status.new(nil, :success)
collection.update second_collection
assert_equal [3, 1, 2, 1], collection.values_at(:success, :skipped, :failure, :exception)

# Verify inspect
assert_match(/\A\#<BareTest::StatusCollection:0x[\da-f]+ code=:exception success=3 skipped=1 failure=2 exception=1>\z/, collection.inspect)
