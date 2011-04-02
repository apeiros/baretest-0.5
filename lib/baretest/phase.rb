# Encoding: utf-8
#
# Copyright 2009-2011 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.



require 'baretest'
require 'baretest/status'
require 'baretest/codesource'



module BareTest

  # @author   Stefan Rusterholz <contact@apeiros.me>
  # @since    0.5.0
  # @topic    Phases
  # @abstract
  #
  # Baseclass that encapsulates the phases in a test.
  # A test consists of the four phases setup, exercise, verify and teardown.
  # But a test can have multiple setup routines, and multiple teardown routines. Each
  # will be encapsulated in a Phase instance.
  class Phase
    class StatusException < StandardError; end
    class Pending < StatusException; end
    class Failure < StatusException; end

    PendingNoCode = Pending.new("No code provided")

    attr_reader :codeblock

    # @return [Boolean]
    #   Whether execution of the phase has returned a value
    #   see #call, #return_value
    attr_reader :returned
    alias returned? returned

    # @return [Object]
    #   The value the execution of the phase has returned
    #   Make sure to check whether the execution has returned at all first,
    #   since not returning and a return value of nil are indistinguishable
    #   otherwise.
    #
    # see #call, #returned
    attr_reader :return_value

    # @return [nil, Exception]
    #   In case the execution of the phase raised an exception, the exception
    #   object is stored here.
    attr_reader :raised

    # @return [Symbol]
    #   The phase identifier of this Phase instance.
    #   Should be one of
    #   * :initialization
    #   * :setup
    #   * :exercise
    #   * :verify
    #   * :teardown
    #   * :cleanup
    attr_reader :phase

    # @param [Symbol] phase
    #   The phase identifier of this Phase instance.
    #   Should be one of
    #   * :initialization
    #   * :setup
    #   * :exercise
    #   * :verify
    #   * :teardown
    #   * :cleanup
    def initialize(phase, &codeblock)
      @codeblock    = codeblock
      @returned     = false
      @return_value = nil
      @raised       = nil
      @phase        = phase
    end

    # @return [BareTest::CodeSource]
    #   Returns the code of this Phase as CodeSource instance.
    def codesource
      CodeSource.from(@codeblock)
    end

    # @param [Object]
    #   The context within which to evaluate the code-block.
    # @return [self]
    def call(context)
      @returned     = false
      @return_value = nil
      @raised       = nil

      if @codeblock then
        begin
          @return_value = context.instance_eval(&@codeblock)
          @returned     = true
        rescue *BareTest::PassthroughExceptions => exception
          @raised = exception
          raise # reraise passthrough exceptions, we don't handle them
        rescue Exception => exception
          @raised = exception
        end
      else # no code means pending
        @raised = PendingNoCode
      end

      self
    end
  end
end
