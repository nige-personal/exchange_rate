# frozen_string_literal: true

require 'exchange_rate/version'
require_relative 'conversion_provider_handlers'
require_relative 'conversion_store_handlers'
require_relative 'exceptions.rb'
require_relative 'shared_values'

# TODO MUST add logging!!
module ExchangeRate
  DEFAULT_STORE_HANDLER = 'json'.freeze
  DEFAULT_PROVIDER_HANDLER = 'ecb'.freeze

  def self.at(date, base, target)
    # ecb dont produce an update on weekends
    # if a weekend date is supplied we could use the data from the friday - future work?
    raise Exception::ArgumentError, 'date, base or target cannot be nil' if [date, base, target].include? nil
    calculate_conversion(date, base.upcase, target.upcase)
  end

  def self.update_conversion_data(provider_name=nil, store_name=nil)
    provider = provider_name || ENV.fetch(SharedValues::CONVERSION_PROVIDER_HANDLER, DEFAULT_PROVIDER_HANDLER)
    store = store_name || ENV.fetch(SharedValues::CONVERSION_STORE_HANDLER, DEFAULT_STORE_HANDLER)
    unless provider && store
      provider_handlers = ConversionProviderHandlers.registered_handlers
      store_handlers = ConversionStoreHandlers.registered_handlers

      error_message = 'Handler environment variables (DEFAULT_PROVIDER_HANDLER and DEFAULT_STORE_HANDLER) not set. '
      error_message += "DEFAULT_PROVIDER_HANDLER registered handlers: #{provider_handlers.map { |handler_Hash| handler_Hash[1]::IDENTIFIER }}. "
      error_message += "DEFAULT_STORE_HANDLER registered handlers: #{store_handlers.map { |handler_Hash| handler_Hash[1]::IDENTIFIER }}. "
      error_message += 'Handler environment variables not set, aborting....'
      raise error_message
    end
    puts "populating #{store} store with #{provider} currency rates"

    conversion_rate_handler = ConversionStoreHandlers.obtain(store)

    conversion_provider_handler = ConversionProviderHandlers.obtain(provider)
    kvps = conversion_provider_handler.conversion_data_kvps

    conversion_rate_handler.populate_store(kvps)
  end

  def self.calculate_conversion(date, base, target)
    store_handler = ENV.fetch(SharedValues::CONVERSION_STORE_HANDLER, DEFAULT_STORE_HANDLER)

    data_store = ConversionStoreHandlers.obtain(store_handler)

    conversion_rates = data_store.get_rates_for(date, base, target)
    base_currency = conversion_rates[SharedValues::BASE_CURRENCY]

    target_rate = conversion_rates[target]
    base_rate = conversion_rates[base]

    base_rate = 1 if base == base_currency
    target_rate = 1 if target == base_currency

    rate = conversion_rate(base_rate, target_rate)
    {rate: rate, date: date, base_currency: base_currency}
  end

  def self.conversion_rate(base, target)
    return target if base == 0
    target / base
  end
end
