# Encoding: utf-8

#--
# Copyright 2009-2011 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module BareTest

  # @author Stefan Rusterholz <contact@apeiros.me>
  # @since  0.5.0
  # @topic  Status, Test
  #
  # The status of a Phase, Test, Suite or Run
  # In case of a failure, it also contains the failure reason and the context
  # where the failure happened (@see BareTest::Phase).
  # In case of an exception, it additionally contains the exception object.
  #
  # Possible states are hierarchical:
  #
  # * Unrun
  #   The entity has not been considered for running. This can be due to
  #   selectors, tags etc.
  # * Run
  #   The entity has been run
  #   * Success
  #     The entity did run as expected.
  #     Associated with black on green in standard output.
  #   * Abort
  #     The entity could not be run or did not run as expected
  #     * Exception
  #       The code raised a (by the test) unhandled exception
  #       Associated with yellow on black in standard output.
  #     * Failure
  #       The actual outcome of the test different from the expected outcome
  #       Associated with black on red in standard output.
  #   * Skipped
  #     The test was not executed
  #     Associated with black on yellow in standard output.
  #     * Pending
  #       It was not implemented or explicitly marked as pending
  #     * MissingLibrary
  #       A library this entity declared as requirement could not be loaded
  #     * MissingComponent
  #       A baretest component this entity depends on could not be loaded
  #     * MissingDependency
  #       A specified dependency on another entitys success was not met
  #
  # The mapping of those hierarchical states to codes is as follows:
  # * Unrun: is not mapped
  # * Success:     :success
  # * Exception:   :exception
  # * Failure:     :failure
  # * Skipped:     :skipped
  #
  # The states' prevalence is: exception, failure, skipped, success.
  #
  class Status

    # All codes in order of importance
    Codes = {
      :exception => 0,
      :failure   => 1,
      :skipped   => 2,
      :success   => 3,
    }

    # @return [BareTest::Phase, BareTest::Test, BareTest::Suite, BareTest::Run]
    #   The phase, test, suite or run this status belongs to
    attr_reader :entity

    # @return [Symbol]
    #   The phase  execute context.
    attr_reader :phase

    # @return [Symbol]
    #   The status identifier, one of :
    attr_reader :code

    # @return [nil, Array<String>]
    #   Detailed reason for the status.
    #   Success usually has no reason.
    attr_reader :reason

    # @return [nil, Exception]
    #   Only present for status exception. The exception object that was raised
    #   and caused the exception status.
    attr_reader :exception

    # @param [BareTest::Phase, BareTest::Test, BareTest::Suite, BareTest::Run] entity
    #   The entity this Status belongs to.
    # @param [Symbol] code
    #   The status code, one of the keys in {Codes}
    # @param [Symbol] phase
    #   The phase name at which the status was determined.
    #   Success will usually have the phase :cleanup, skipped usually :setup and
    #   the others :execution, :verify or :teardown.
    # @param [nil, String, Array<String>] reason
    #   The detailed reason in case of :skipped, :failure or :exception
    # @param [Exception] exception
    #   The exception that cased the exception status in case of :exception
    def initialize(entity, code, phase=:cleanup, reason=nil, exception=nil)
      reason   ||= exception && exception.message
      @entity    = entity
      @code      = code
      @phase     = phase
      @reason    = reason.is_a?(String) ? [reason] : reason
      @exception = exception
    end

    # @private
    # @return [String]
    def inspect
      values  = [self.class, object_id>>1, @code, @phase]
      reason  = @reason && @reason.join("; ").tr("\n","").sub(/\A(.{20}).+/m, '\\1…')
      message = exception && exception.message
      case @code
        when :success
          sprintf "#<%s:0x%x code=%p phase=%p>", *values
        when :exception
          sprintf "#<%s:0x%x code=%p phase=%p reason=%p exception=%p>", *values, reason, message
        else
          sprintf "#<%s:0x%x code=%p phase=%p reason=%p>", *values, reason
      end
    end
  end
end
