ENV["RAILS_ENV"] = "test"

require File.expand_path("../rails_app/config/environment.rb", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara'
require 'rake' 

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

SERVERPORT = IO.read(File.expand_path("../PORT",__FILE__)).strip # port number that we are using
SERVERSLOWPORT = IO.read(File.expand_path("../SLOWPORT",__FILE__)).strip # a port with artificially slowed down loading

R30SERVERPORT = IO.read(File.expand_path("../R30PORT",__FILE__)).strip # port number for rails 3.0 app
SERVERIP = "0.0.0.0"

module Retryable
  # retry code n times
  def retry_exceptions(n = 3)
    i=0
    begin
      yield i
    rescue
      retry if (i += 1) < n
      raise # if not retrying then raise
    end
  end
end

