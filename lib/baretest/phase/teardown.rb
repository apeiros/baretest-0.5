# Encoding: utf-8
#
# Copyright 2009-2011 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.



require 'baretest/phase'



module BareTest
  class Phase

    # @author   Stefan Rusterholz <contact@apeiros.me>
    # @since    0.5.0
    # @topic    Phases
    #
    # Phases that are executed in order to tear down a context after exercise and verification
    # have been run.
    # Teardown phases are hold by the TestBed class.
    class Teardown < Phase
      def initialize(&block)
        super(:teardown, &block)
      end
    end
  end
end
