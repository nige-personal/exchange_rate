require 'handler_registerable'

module ConversionStoreHandlers
  extend HandlerRegisterable::Registry

  class Base
    def initialize(context)
      @context = context
    end

    # Registers a handler with the given identifier.
    #
    # @param [Symbol] handler the identifier to represent this handler class.
    def self.register(handler)
      ConversionStoreHandlers.register self, handler
    end
  end
end
