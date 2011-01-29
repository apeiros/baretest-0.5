# Encoding: utf-8
#
# To run the bootstrap, change to the project root of baretest and then execute:
#   ruby test/bootstrap.rb
#
# ABOUT THIS FILE
# bootstrap.rb runs the bootstrap tests for baretest.

section = "__initialize__"

begin
  Bootstrap = {}
  Bootstrap[:base]      = File.expand_path('.')
  Bootstrap[:lib]       = File.expand_path(File.join(Bootstrap[:base], 'lib'))
  Bootstrap[:test]      = File.expand_path(File.join(Bootstrap[:base], 'test'))
  Bootstrap[:bootstrap] = File.expand_path(File.join(Bootstrap[:base], 'test', 'bootstrap'))

  $LOAD_PATH.unshift(Bootstrap[:lib])

  # sanity check: ruby version
  section = "__sanity_check_ruby_version__"
  running_version   = RUBY_VERSION.scan(/\d+/).map { |segment| segment.to_i }
  required_provided = (running_version <=> [1,9,2]) >= 0
  raise "Bootstrap requires ruby version 1.9.2 or higher" unless required_provided

  # sanity check: presence of baretest
  section = "__sanity_check_directories__"
  raise "Project root is not a directory" unless File.directory?(Bootstrap[:base])
  raise "Directory 'lib' is missing - are you running bootstrap from the project root?" unless File.directory?(Bootstrap[:lib])
  raise "Directory 'test' is missing - are you running bootstrap from the project root?" unless File.directory?(Bootstrap[:test])
  raise "Directory 'test/bootstrap' is missing - are you running bootstrap from the project root?" unless File.directory?(Bootstrap[:bootstrap])

  # define some primitive assertions
  def assert(value, message=nil)
    raise(message || "Assertion failed") unless value
  end
  def assert_same(expected, actual, message=nil)
    raise(message || "Expected #{expected.inspect} and #{actual.inspect} to be identical") unless expected.equal?(actual)
  end
  def assert_equal(expected, actual, message=nil)
    raise(message || "Expected #{expected.inspect} and #{actual.inspect} to be equal") unless expected == actual
  end
  def assert_match(expected, actual, message=nil)
    raise(message || "Expected #{expected.inspect} to match #{actual.inspect}") unless expected =~ actual
  end
  def assert_raises(message)
    yield
  rescue
    # ok
  else
    raise(message || "Expected the codeblock to raise")
  end

  $stdout.sync = true
  # perform the bootstrapping
  %w[
    baretest/status
    baretest/status_collection
    baretest/phase
    baretest/phase/exercise
  ].each do |current|
    section = current
    print "Bootstrapping #{section}…"
    load(File.join(Bootstrap[:bootstrap], section+".rb"))
    printf "\r\e[42m %-78s \e[0m\n", "Bootstrapped section #{section}"
  end

rescue Exception => e
  puts
  printf "\e[1;41m %-78s \e[0m\n", "BOOTSTRAPPING FAILED (section #{section})"
  puts "#{e.class}:#{e}", *e.backtrace
  exit 1 # enable automated use
else
  printf "\e[1;42m %-78s \e[0m\n", "BOOTSTRAPPING SUCCESSFUL"
  exit 0 # normal, but let's be explicit
end
