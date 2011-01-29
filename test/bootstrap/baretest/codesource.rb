# Encoding: utf-8

require 'baretest/codesource'
require File.join(Bootstrap[:support], 'sourcecode')

# Missing arguments
assert_raises "Expected BareTest::CodeSource.new to raise without arguments" do
  BareTest::CodeSource.new
end
assert_raises "Expected BareTest::CodeSource.new to raise with only 1 argument" do
  BareTest::CodeSource.new("def fakedef\n  :fakereturn\nend")
end

# Happy path, simple
code        = "def fakedef\n  :fakereturn\nend"
file        = "fakefile.rb"
code_source = BareTest::CodeSource.new(code, file)
assert_equal 1, code_source.starting_line
assert_equal file, code_source.file
assert_equal code, code_source.code
assert_same nil, code_source.instance_variable_get(:@to_s) # nasty way to check caching
code_source.to_s
assert !code_source.instance_variable_get(:@to_s).nil? # nasty way to check caching
assert_match(/\A\#<BareTest::CodeSource:0x[\da-f]+ file="#{file}" line=1 code=`def fakedef; :fakereturn; end`>\z/, code_source.inspect)
assert_equal <<-CODE_TO_S, code_source.to_s
  | Code of fakefile.rb:1
  |
  | \e[1m1\e[0m   def fakedef
  | \e[1m2\e[0m     :fakereturn
  | \e[1m3\e[0m   end
CODE_TO_S

# With a highlight
code_source.options! :highlight => 2
assert_equal <<-CODE_TO_S, code_source.to_s
  | Code of fakefile.rb:1
  |
  | \e[1m1\e[0m   def fakedef
  | \e[1m2\e[0m   \e[43m  :fakereturn                                                                   \e[0m
  | \e[1m3\e[0m   end
CODE_TO_S

# Highlighting a range of lines
code_source.options! :highlight => 2..3
assert_equal <<-CODE_TO_S, code_source.to_s
  | Code of fakefile.rb:1
  |
  | \e[1m1\e[0m   def fakedef
  | \e[1m2\e[0m   \e[43m  :fakereturn                                                                   \e[0m
  | \e[1m3\e[0m   \e[43mend                                                                             \e[0m
CODE_TO_S

# Highlighting a length lines from a given offset
code_source.options! :highlight => [1,2]
assert_equal <<-CODE_TO_S, code_source.to_s
  | Code of fakefile.rb:1
  |
  | \e[1m1\e[0m   \e[43mdef fakedef                                                                     \e[0m
  | \e[1m2\e[0m   \e[43m  :fakereturn                                                                   \e[0m
  | \e[1m3\e[0m   end
CODE_TO_S

# Extract from a proc
code_source = BareTest::CodeSource.from(Support::Block1)
assert_is_a BareTest::CodeSource, code_source
assert_equal Support::Block1Info[:file], code_source.file
assert_equal Support::Block1Info[:line], code_source.starting_line

# Happy path, IRB
code        = "def fakedef\n  :fakereturn\nend\n"
file        = "(irb)"

# some stubs
stub_proc = Object.new
def stub_proc.source_location
  ["(irb)", 3]
end
module IRB
  @line_no = 8
  def self.CurrentContext
    self
  end
end
module Readline
  HISTORY = Object.new
  def HISTORY.to_a
    [
      "fake - previous session\n",
      "fake - previous session\n",
      "fake - current session, line 1\n",
      "fake - current session, line 2\n",
      "  def fakedef\n",       # line 3
      "    :fakereturn\n",     # line 4
      "  end\n",               # line 5
      "fake - current session, line 6\n",
      "fake - current session, line 7\n",
      "fake - current session, line 8\n",
    ]
  end
end

code_source = BareTest::CodeSource.from(stub_proc)
assert_equal 3, code_source.starting_line
assert_equal file, code_source.file
assert_equal code, code_source.code
assert_match(/\A\#<BareTest::CodeSource:0x[\da-f]+ file="#{Regexp.escape(file)}" line=3 code=`def fakedef; :fakereturn; end`>\z/, code_source.inspect)
assert_equal <<-CODE_TO_S, code_source.to_s
  | Code of (irb):3
  |
  | \e[1m3\e[0m   def fakedef
  | \e[1m4\e[0m     :fakereturn
  | \e[1m5\e[0m   end
CODE_TO_S
