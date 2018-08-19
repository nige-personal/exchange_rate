require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'json'

require_relative 'lib/conversion_provider_handlers'
require_relative 'lib/conversion_store_handlers'
require_relative 'lib/exchange_rate'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :conversion do
  desc 'populate the current store with currency rates'
  task :populate_store, :env do
    ExchangeRate.update_conversion_data
  end
end
