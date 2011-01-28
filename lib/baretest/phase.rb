# Encoding: utf-8
#--
# Copyright 2009-2010 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'baretest/status'



module BareTest

  # @author Stefan Rusterholz <contact@apeiros.me>
  # @since  0.5.0
  # @topic  Phases
  #
  # Baseclass that encapsulates the single phases in a test.
  # A test consists of the four phases setup, exercise, verify and teardown.
  class Phase
    attr_reader :user_codeblock
    attr_reader :execute_codeblock

    def initialize(&codeblock)
      @user_codeblock    = codeblock
      @execute_codeblock = codeblock
    end

    def user_codesource
      CodeBlock.baretest(@user_codeblock)
    end

    def phase
      raise "Your Phase subclass #{self.class.to_s} must override #phase."
    end

    def execute(test)
      raise Pending.new(phase, "No code provided") unless @code # no code? that means pending

      context = test.context
      context.__phase__ = phase
      context.instance_eval(&@code)
    end
  end
end



require 'baretest/phase/setup'
require 'baretest/phase/exercise'
require 'baretest/phase/verification'
require 'baretest/phase/teardown'
require 'baretest/phase/abortion'
