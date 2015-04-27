require 'rubygems'
require 'bundler/setup'

require 'simplecov'
require 'simplecov-gem-adapter'

require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'gem'

require 'mongoid'
require 'active_record'
require 'active_mongoid'
require 'database_cleaner'

require 'pry'

require 'rspec'

Mongoid.configure do |config|
  version = ::Gem::Version.new(Mongoid::VERSION)
  if version >= ::Gem::Version.new("3.0.0")
    config.sessions = {
      default: {
        database: 'active_mongoid_test',
        hosts: [ (ENV['MONGO_HOST'] || 'localhost')+':27017' ],
        options: { read: :primary }
      }
    }
  else
    config.master = Mongo::Connection.new.db('active_mongoid_test')
    config.allow_dynamic_fields = false
  end
  config.identity_map_enabled = false if config.respond_to?(:identity_map_enabled)
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :suite do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with :truncation
    DatabaseCleaner[:mongoid].clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner[:active_record].start
    DatabaseCleaner[:mongoid].start
  end

  config.after :each do
    DatabaseCleaner[:active_record].clean
    DatabaseCleaner[:mongoid].clean
  end
end


ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Schema.define do
  create_table :players, :force => true do |t|
    t.string :_id
    t.string :name
    t.string :title
    t.string :team_id
  end

  create_table :divisions, :force => true do |t|
    t.string :_id
    t.string :name
    t.string :league_id
    t.string :pid
    t.string :sport_id
  end

  create_table :division_settings, :force => true do |t|
    t.string :_id
    t.string :name
    t.string :league_id
  end

  create_table :addresses, :force => true do |t|
    t.string :_id
    t.string :target_id
    t.string :target_type
  end

  create_table :plays, :force => true, :id => false do |t|
    t.string :id
    t.string :name
    t.string :sport_id
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
