require 'baretest/statuscollection'

# An empty collection has no status code
collection = BareTest::StatusCollection.new
assert_equal nil, collection.code

# A collection with only a success has the code :success
collection << BareTest::Status.new(:success, :cleanup)
assert_equal :success, collection.code

# A collection with a success and a pending has the code :pending
collection << BareTest::Status.new(:pending, :cleanup)
assert_equal :pending, collection.code

# A collection with a success, a pending and a failure has the code :failure
collection << BareTest::Status.new(:failure, :cleanup)
assert_equal :failure, collection.code

# Adding another success will not change the code to be :failure
collection << BareTest::Status.new(:success, :cleanup)
assert_equal :failure, collection.code

# A collection with a success, a pending, a failure and an exception has the
# code :exception
collection << BareTest::Status.new(:exception, :cleanup)
assert_equal :exception, collection.code

# Verify the counts
assert_equal [2], collection.values_at(:success)

# Verify mergin two collections
second_collection = BareTest::StatusCollection.new
second_collection << BareTest::Status.new(:failure, :cleanup)
second_collection << BareTest::Status.new(:success, :cleanup)
collection.update second_collection
assert_equal [3, 1, 2, 1], collection.values_at(:success, :pending, :failure, :exception)

# Verify inspect
assert_match(/\A\#<BareTest::StatusCollection:0x[\da-f]+ code=:exception success=3 pending=1 failure=2 exception=1>\z/, collection.inspect)
