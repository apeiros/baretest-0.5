module BareTest

  class StatusCollection
    # @return [Symbol]
    #   The status identifier, see BareTest::Status.
    attr_reader :count

    def initialize
      @count  = Hash.new(0)
    end

    # @param [StatusCollection] status_collection to update this one with
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

    def values_at(*args)
      @count.values_at(*args)
    end

    # @return[Symbol, nil] most prevalent status code
    def code
      BareTest::Status::Codes.keys.find { |status| @count[status] > 0 }
    end

    def inspect # :nodoc:
      sprintf "#<%s:%p:%s count: %p>",
        self.class,
        @count
    end
  end
end

