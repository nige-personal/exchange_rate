require 'handler_registerable'

module ConversionProviderHandlers
  extend HandlerRegisterable::Registry

  class Base
    def initialize(context)
      @context = context
    end

    # Registers a handler with the given identifier.
    #
    # @param [Symbol] handler the identifier to represent this handler class.
    def self.register(handler)
      ConversionProviderHandlers.register self, handler
    end
  end
end
