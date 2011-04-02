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
    # Phases that are executed in order to set the context up.
    # Setup phases are hold by the TestBed class.
    class Setup < Phase
      def initialize(&block)
        super(:setup, &block)
      end
    end
  end
end
