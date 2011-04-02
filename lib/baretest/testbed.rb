# Encoding: utf-8
#
# Copyright 2009-2011 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.



require 'baretest/phase/setup'



module BareTest

  # @author   Stefan Rusterholz <contact@apeiros.me>
  # @since    0.5.0
  # @topic    ?
  #
  # 
  class TestBed
    def initialize
      @setups     = []
      @teardowns  = []
    end

    def define_setup(&block)
      @setups << Phase::Setup.new(&block)
    end

    def define_teardown(&block)
      @teardowns << Phase::Teardown.new(&block)
    end

    def call(context)
      @setups.each do |setup| setup.call(context) end
      yield(context)
      @teardowns.each do |teardown| teardown.call(context) end
    end
  end
end
