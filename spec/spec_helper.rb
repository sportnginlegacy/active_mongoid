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
  if Mongoid::VERSION >= "3"
    config.connect_to('active_mongoid_test')
  else
    config.master = Mongo::Connection.new.db('active_mongoid_test')
    config.allow_dynamic_fields = false
  end
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :suite do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with :truncation
    DatabaseCleaner[:mongoid].clean_with :truncation
  end

  config.around :each do |example|
    DatabaseCleaner[:active_record].cleaning do
      DatabaseCleaner[:mongoid].cleaning do
        example.run
      end
    end
  end
end


ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Schema.define do
  create_table :players, :force => true do |t|
    t.string :name
    t.string :team_id
  end

  create_table :divisions, :force => true do |t|
    t.string :name
    t.string :league_id
    t.string :pid
  end

  create_table :division_settings, :force => true do |t|
    t.string :name
    t.string :league_id
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
