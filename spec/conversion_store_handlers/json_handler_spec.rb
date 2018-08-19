require 'spec_helper'

RSpec.describe ConversionStoreHandlers::JsonHandler do
  subject(:json_handler) { describe_class }

  describe '#handles?' do
    context 'when a handler is registered with the base class' do
      it 'expects the correct handler to be returned' do
        handler_id = ConversionStoreHandlers::JsonHandler::IDENTIFIER
        handler = ConversionStoreHandlers.obtain(handler_id)

        expect(handler).to be_a ConversionStoreHandlers::JsonHandler
      end
    end
  end
end
