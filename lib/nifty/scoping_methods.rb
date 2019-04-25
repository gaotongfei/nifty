module Nifty
  module ScopingMethods #:nodoc:
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def nifty
        all
      end
    end

  end
end