# Encoding: utf-8
#
# Copyright 2009-2011 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.



module BareTest

  # @author   Stefan Rusterholz <contact@apeiros.me>
  # @since    0.5.0
  # @topic    Phases
  #
  # A class to present source code on a terminal.
  # It provides utilities to extract the source straight from a proc instance.
  #
  # IMPORTANT: The class currently depends on proper indentation.
  #
  # @see BareTest::CodeSource.from
  class CodeSource

    # The defaults for CodeSource#initialize' options argument
    DefaultOptions = {
      :highlight          => nil,
      :header             => "  | Code of %s:%d\n  |\n",
      :template           => "  | \e[1m%0*d\e[0m   %s\n",
      :highlight_template => "  | \e[1m%0*d\e[0m   \e[43m%-80s\e[0m\n", # or 46?
      :footer             => "",
      :line_numbers       => true,
    }

    # @param [Proc] proc_instance
    #   A proc instance to extract the code of
    # @return [nil, SourceCode]
    #   Returns nil if the source code could not be extracted, otherwise
    #   it returns a source code instance with all code that is indented
    #   at least as much as the first line to extract.
    def self.from(proc_instance, highlight=nil, opts={})
      file, line = *proc_instance.source_location
      new source_from_file_and_line(file, line),
          file,
          line,
          opts.merge(:highlight => highlight)
    end

    # @return [String]
    #   Returns the code that is indented at least as much as the first line
    #   to extract.
    def self.source_from_file_and_line(file, from_line=1)
      if file == "(irb)" then # irb special case
        raise "Requires Readline to extract lines from irb" unless defined?(::Readline::HISTORY.to_a)
        raise "Requires the current line number from irb to extract lines from irb" unless defined?(::IRB.CurrentContext.instance_variable_get(:@line_no))
        slice = -::IRB.CurrentContext.instance_variable_get(:@line_no)..-1
        lines = ::Readline::HISTORY.to_a[slice]
      else
        lines  = File.readlines(file)
      end
      string = lines[(from_line-1)..-1].join("").sub(/[\r\n]*\z/, '')
      string.gsub!(/^\t+/) { |m| "  "*m.size }
      indent = string[/^ */]
      string.gsub!(/^ {0,#{indent.size-1}}[^ ].*\z/m, '') # drop everything that is less indented
      string.gsub!(/^#{indent}/, '') # unindent
      string
    end

    # @return [String] The code
    attr_reader :code

    # @return [String] The name of the file from which the code is
    attr_reader :file

    # @return [Integer] The starting line number from which the code is
    attr_reader :starting_line

    # @return [Hash]
    #   The set of options chosen to display this source code.
    #   Warning, this hash is always frozen.
    #   @see #options!
    #   @see DefaultOptions
    attr_reader :options

    # @param [String] code
    #   The source code to display
    # @param [String] file_name
    #   The file name to display as the source of the code
    # @param [Integer] starting_line
    #   From which line on in the file the source starts
    # @param [nil, Hash] options
    #   Options to customize the presentation of the source code
    #   see {BareTest::CodeSource::DefaultOptions}
    def initialize(code, file_name, starting_line=1, options={})
      @code          = code
      @file          = file_name
      @starting_line = starting_line
      @options       = DefaultOptions
      options!(options)
    end

    # Update the options
    # @param [nil, Hash] options
    #   Options to customize the presentation of the source code.
    #   Nil doesn't change the current options.
    #   see {BareTest::CodeSource::DefaultOptions}
    #
    # @return [self]
    #   Returns self.
    def options!(value)
      @options = value ? @options.merge(value) : @options.dup
      @to_s    = nil
      highlight            = @options[:highlight]
      @options[:highlight] = case highlight
        when nil then []
        when Integer then [highlight]
        when Array then highlight
        else highlight.to_a
      end
      @options.freeze

      self
    end

    # Presents the code as specified by the options.
    #
    # @return [String] The formatted code
    def to_s
      @to_s ||= begin
        line_number        = @starting_line
        line_count         = @code.count("\n")
        normal_template    = @options[:template]
        highlight_template = @options[:highlight_template]
        highlight          = @options[:highlight]
        digits             = Math.log10(@starting_line+line_count).floor+1
        output             = []
        output            << sprintf(@options[:header], @file, line_number)
        @code.each_line do |line|
          template = highlight.include?(line_number) ? highlight_template : normal_template
          output  << sprintf(template, digits, line_number, line.chomp)
          line_number += 1
        end
        output << @options[:footer]
        @to_s = output.compact.join("")
      end
    end

    # @private
    # @return [String]
    def inspect
      code = @code.gsub(/\n(?!\s*\z)/m,"; ").strip.squeeze(' ').sub(/\A(.{40}).+/m, '\\1…')
      sprintf '#<%s:0x%x file=%p line=%d code=`%s`>', self.class, object_id>>1, @file, @starting_line, code
    end
  end
end
