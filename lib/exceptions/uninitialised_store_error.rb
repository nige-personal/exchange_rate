module Exceptions
  class UninitialisedStoreError < StandardError
    def initialize(msg = 'The store has not been initialised with data')
      super
    end
  end
end
