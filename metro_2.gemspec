# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metro_2/version'

Gem::Specification.new do |spec|
  spec.name          = "metro_2"
  spec.version       = Metro2::VERSION
  spec.authors       = ["Brian Mascarenhas"]
  spec.email         = ["brian@brianmascarenhas.com"]
  spec.summary       = "Create Metro 2 format files for credit reporting"
  spec.description   = "Create Metro 2 format files for credit reporting"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
