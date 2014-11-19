require "active_mongoid/associations"
require "active_mongoid/bson_id"
require "active_mongoid/finder_proxy"
require "active_mongoid/finders"

module ActiveMongoid
  BSON = ::Gem::Version.new(Mongoid::VERSION) < ::Gem::Version.new("3.0.0") ? ::BSON : ::Moped::BSON
end
