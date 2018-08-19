
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exchange_rate/version'

Gem::Specification.new do |spec|
  spec.name          = 'exchange_rate'
  spec.version       = ExchangeRate::VERSION
  spec.authors       = 'Nigel Surtees'
  spec.email         = 'nigelsurtees@hotmail.co.uk'

  spec.summary       = 'Currency converter'
  spec.description   = 'Provides the means to convert currencies based on the latest conversion rates for that day'
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'bigdecimal'
  spec.add_dependency 'eu_central_bank'
  
  # Copyright 2016 The Sage Group Plc
  # Licensed under the Apache License, Version 2.0 (the "License");
  # You may obtain a copy of the License at
  # http://www.apache.org/licenses/LICENSE-2.0
  spec.add_dependency 'handler_registerable'
  
 
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rake', '~> 10.0'
end
