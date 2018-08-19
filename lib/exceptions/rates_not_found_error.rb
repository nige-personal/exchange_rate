module Exceptions
  class RatesNotFoundError < StandardError
    def initialize(msg = 'Rates not available for the criteria provided')
      super
    end
  end
end
