# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'bigdecimal'

module ConversionProviderHandlers
  class EcbHandler < Base
    register :ecb_handler

    IDENTIFIER = 'ecb'.freeze
    ECB_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.freeze
    XML_PATH_TO_CONVERSION_DATA = 'gesmes:Envelope/xmlns:Cube/xmlns:Cube'.freeze

    DOWNLOAD_ERRORS = [
      SocketError,
      OpenURI::HTTPError,
      RuntimeError,
      URI::InvalidURIError,
      StandardError
    ].freeze

    def self.handles?(context)
      context == IDENTIFIER
    end

    def conversion_data_kvps
      xml_doc = download_conversion_xml
      extract_conversion_data_tojson(xml_doc)
    end

    private

    def extract_conversion_data_tojson(xml_doc)
      conversion_data = {}

      raw_conversion_data = xml_doc.xpath(XML_PATH_TO_CONVERSION_DATA)
      raw_conversion_data.each do |conversion_datum|
        conversion_for_date = {}

        conversion_datum.children.each do |child|
          rate = BigDecimal(child.attribute('rate').value)
          conversion_for_date[child.attribute('currency').value] = rate
        end
        conversion_data[conversion_datum.attribute('time').value] = conversion_for_date
      end
      conversion_data
    end

    def download_conversion_xml
      url = URI.encode(URI.decode(ECB_URL))
      url = URI(url)
      raise Error, 'Invalid URL' unless url.respond_to?(:open)

      options = {}
      options['User-Agent'] = "ExchangeRate #{ExchangeRate::VERSION}"

      downloaded_file = url.open(options)
      Nokogiri::XML(File.open(downloaded_file)).tap { |doc| doc.xpath(XML_PATH_TO_CONVERSION_DATA) }
    rescue *DOWNLOAD_ERRORS => error
      raise StandardError, "Download failed (#{url}): #{error.message}"
    end
  end
end
# conversion_provider_handler = ConversionProviderHandlers.obtain('ecb'); kvps = conversion_provider_handler.conversion_data_kvps
