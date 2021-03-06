# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "smart_que/version"

Gem::Specification.new do |spec|
  spec.name          = "smart-que"
  spec.version       = SmartQue::VERSION
  spec.authors       = ["Ashik Salman"]
  spec.email         = ["ashiksp@gmail.com"]

  spec.summary       = %q{Queue Publisher & Consumer}
  spec.description   = %q{Publish messages to RabbitMq broker and Consume with independent workers.}
  spec.homepage      = "https://github.com/ashiksp/smart_que"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Run time dependencies
  spec.add_runtime_dependency "bunny", "~> 2.11"
  spec.add_runtime_dependency "connection_pool", "~> 2.2"

  # Development Dependencies
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.11"
end
