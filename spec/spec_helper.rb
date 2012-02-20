ENV["RAILS_ENV"] = "test"

require File.expand_path("../rails_app/config/environment.rb", __FILE__)
#require "rails_app/config/environment"
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara'
require 'rake' 

require 'ajax_pagination'

Rails.backtrace_cleaner.remove_silencers!

Capybara.app = RailsApp::Application

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :browser => :chrome)
end

include Capybara::DSL



