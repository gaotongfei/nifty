module Nifty
  class Inspector
    include Enumerable

    def initialize(result)
      @result = result
    end

    def each(&block)
      @result.each(&block)
    end

    def inspect
      @result.take(10)
    end

    def length
      size
    end

    alias size count
  end
end