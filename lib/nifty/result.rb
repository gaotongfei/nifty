module Nifty
  class Result
    def initialize(result)
      @result = result
    end

    # @param :result [Hash]
    def self.build(result)
      new(result).build
    end

    def build
      @result.each do |k, v|
        self.class.send(:attr_accessor, k.to_sym)
        instance_variable_set("@#{k}", v)
      end
      self
    end

    def inspect
      @result
    end
  end
end