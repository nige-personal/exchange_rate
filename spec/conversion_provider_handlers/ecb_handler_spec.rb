require 'spec_helper'

RSpec.describe ConversionProviderHandlers::EcbHandler do
  subject(:ecb_handler) { describe_class }

  describe '#handles?' do
    context 'when a handler is registered with the base class' do
      it 'expects the correct handler to be returned' do
        handler_id = ConversionProviderHandlers::EcbHandler::IDENTIFIER
        handler = ConversionProviderHandlers.obtain(handler_id)

        expect(handler).to be_a ConversionProviderHandlers::EcbHandler
      end
    end
  end
end
