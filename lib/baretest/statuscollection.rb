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
  # A StatusCollection keeps track of the amount of different states and the
  # most prevalent status code (see {BareTest::Status::Codes} for the prevalence
  # order).
  class StatusCollection
    # @return [Symbol]
    #   The status identifier, see BareTest::Status.
    attr_reader :count

    def initialize
      @count  = Hash.new(0)
    end

    # @param [StatusCollection] status_collection
    #   Updates this StatusCollection with the values of the given
    #   status_collection by adding all counts against its own.
    # @return self
    def update(status_collection)
      @count.update(status_collection.count) do |key, my_value, other_value|
        my_value+other_value
      end
      self
    end

    # @param [Status] status to be added to this collection
    def <<(status)
      @count[status.code] += 1
    end

    # Get the counts for multiple status codes at once.
    #
    # @param [*Symbol] *codes
    #   The values for which codes to return
    #
    # @example
    #   collection = BareTest::StatusCollection.new
    #   3.times do collection << BareTest::Status.new(nil, :success) end
    #   2.times do collection << BareTest::Status.new(nil, :failure) end
    #   collection.values_at(:success, :failure, :skipped) # => [3, 2, 0]
    def values_at(*codes)
      @count.values_at(*codes)
    end

    # @return[Symbol, nil] most prevalent status code
    def code
      BareTest::Status::Codes.keys.find { |status| @count[status] > 0 }
    end

    # @private
    # @return [String]
    def inspect
      sprintf "#<%s:0x%x code=%p %s>",
        self.class,
        object_id >> 1,
        code,
        BareTest::Status::Codes.keys.reverse.map { |key| "#{key}=#{@count[key]}" }.join(" ")
    end
  end
end

