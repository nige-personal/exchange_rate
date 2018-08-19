require 'spec_helper'

RSpec.describe ConversionStoreHandlers::Base do
  module ConversionStoreHandlers
    class StoreDummyHandler < Base
      register :store_dummy_handler

      def self.handles?(context)
        context === 'store_dummy_handler'
      end
    end
  end

  describe '#register' do
    context 'when a handler is registered with the base class' do
      it 'expects the handler to be registered' do
        handlers = ConversionStoreHandlers.registered_handlers
        expect(handlers.keys).to include(:store_dummy_handler)
      end
    end
  end
end
