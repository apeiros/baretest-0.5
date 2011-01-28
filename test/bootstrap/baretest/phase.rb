require 'baretest/phase'

raise "Missing Phase" unless defined? BareTest::Phase

phase = BareTest::Phase.new
phase.execute
raise "Status should be pending" unless phase.status.pending?
