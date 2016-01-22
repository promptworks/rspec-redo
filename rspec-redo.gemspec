# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec-redo/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-redo"
  spec.version       = RSpecRedo::VERSION
  spec.authors       = ["Ray Zane"]
  spec.email         = ["ray@promptworks.com"]

  spec.summary       = %q{Rerun RSpec failures automatically}
  spec.description   = %q{Automatically rerun RSpec failures using RSpec 3.3.0's built-in --only-failures option}
  spec.homepage      = "http://promptworks.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = 'rspec-redo'
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rspec', '>= 3.3.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov"
end
