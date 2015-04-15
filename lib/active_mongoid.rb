require "active_mongoid/associations"
require "active_mongoid/bson_id"
require "active_mongoid/finder_proxy"
require "active_mongoid/finders"

module ActiveMongoid
  if ::Gem::Version.new(Mongoid::VERSION).between?(::Gem::Version.new("3.0.0"), ::Gem::Version.new("4.0.0"))
    BSON = ::Moped::BSON
  else
    BSON = ::BSON
  end
end
