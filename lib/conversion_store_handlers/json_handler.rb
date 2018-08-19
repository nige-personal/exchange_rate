# frozen_string_literal: true

require 'json'

module ConversionStoreHandlers
  class JsonHandler < Base
    register :json_handler

    LOCAL_DIR_STORE_PATH = File.expand_path('../conversion_data', __dir__)
    TARGET_FILENAME = 'conversion_data.json'.freeze
    IDENTIFIER = 'json'.freeze

    def self.handles?(context)
      context == IDENTIFIER
    end

    def get_rates_for(date, base, target)
      return nil if [date, base, target].include? nil

      begin
        conversion_data = JSON.parse(File.read(LOCAL_DIR_STORE_PATH + '/' + TARGET_FILENAME))
      rescue Errno::ENOENT
        raise ::Exceptions::UninitialisedStoreError
      end
      extract_rates_from_conversion_data(conversion_data, date, base, target)
    end

    def populate_store(conversion_data_kvp)
      conversion_data_kvp[SharedValues::BASE_CURRENCY] = SharedValues::EURO
      File.write(LOCAL_DIR_STORE_PATH + '/' + TARGET_FILENAME, conversion_data_kvp.to_json)
    end

    private

    def extract_rates_from_conversion_data(conversion_data, date, base, target)
      conversion_hash = {}
      conversion_hash['date'] = date

      if conversion_data.nil? || conversion_data.empty?
        raise Exceptions::RatesNotFoundError, 'currency conversion rates not found for date provided'
      end

      begin
        conversion_hash[base] = BigDecimal(conversion_data[date][base]) unless base == conversion_data[SharedValues::BASE_CURRENCY]
        conversion_hash[target] = BigDecimal(conversion_data[date][target]) unless target == conversion_data[SharedValues::BASE_CURRENCY]
        conversion_hash[SharedValues::BASE_CURRENCY] = conversion_data[SharedValues::BASE_CURRENCY]
        conversion_hash
      rescue StandardError
        raise Exceptions::RatesNotFoundError
      end
    end

  end
end
