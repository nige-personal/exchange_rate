require 'spec_helper'

RSpec.describe ConversionProviderHandlers::Base do
  module ConversionProviderHandlers
    class ProviderDummyHandler < Base
      register :provider_dummy_handler

      def self.handles?(context)
        context == 'provider_dummy_handler'
      end
    end
  end

  describe '#register' do
    context 'when a handler is registered with the base class' do
      it 'expects the handler to be registered' do
        handlers = ConversionProviderHandlers.registered_handlers
        expect(handlers.keys).to include(:provider_dummy_handler)
      end
    end
  end
end
