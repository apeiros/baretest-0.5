# To run the bootstrap, change to the project root of baretest and then execute:
#   ruby test/bootstrap.rb

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
  
  # perform the bootstrapping
  %w[
    exercise
  ].each do |current|
    section = current
    puts "Bootstrapping #{section}"
    load(File.join(Bootstrap[:bootstrap], section+".rb"))
  end

rescue Exception => e
  printf "\e[1;41m %-78s \e[0m\n", "BOOTSTRAPPING FAILED (section #{section})"
  puts "#{e.class}:#{e}", *e.backtrace
  exit 1 # enable automated use
else
  printf "\e[1;42m %-78s \e[0m\n", "BOOTSTRAPPING SUCCESSFUL"
  exit 0 # normal, but let's be explicit
end