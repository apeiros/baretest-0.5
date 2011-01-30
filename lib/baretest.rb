# Encoding: utf-8
#--
# Copyright 2009-2011 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



# @author   Stefan Rusterholz <contact@apeiros.me>
# @since    0.5.0
module BareTest

  # The exceptions baretest will not rescue
  # NoMemoryError::   a no-memory error means we don't have enough memory to continue
  # SignalException:: something sent the process a signal to terminate
  # Interrupt::       Ctrl-C was issued, the process should terminate immediatly
  # SystemExit::      the process terminates
  PassthroughExceptions = [
    ::NoMemoryError,
    ::SignalException,
    ::Interrupt,
    ::SystemExit,
  ]
end
