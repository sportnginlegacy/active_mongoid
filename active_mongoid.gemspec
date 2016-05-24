# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = "active_mongoid"
  spec.version       = ActiveMongoid::VERSION
  spec.authors       = ["Bryce Schmidt"]
  spec.email         = ["bryce.schmidt@sportngin.com"]
  spec.summary       = %q{ActiveMongoid provides a relational interface between ActiveRecord and Mongoid objects.}
  spec.description   = %q{ActiveMongoid facilitates usage of both ActiveRecord and Mongoid in a single app by providing an inteface for inter-ORM relations.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "activerecord"
  spec.add_dependency "bson_ext"
  spec.add_dependency "mongoid", '>= 5.0.0'
  spec.add_dependency "after_do"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner", "~> 1.5.2"
  spec.add_development_dependency "pry", "~> 0.10.1"
  spec.add_development_dependency "simplecov", "~> 0.8.0"
  spec.add_development_dependency "simplecov-gem-adapter", "~> 1.0.0"
  spec.add_development_dependency "coveralls", "~> 0.7.0"
  spec.add_development_dependency "appraisal", "~> 1.0.0"
end
