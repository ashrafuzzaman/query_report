$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
begin
  require 'rails'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

#require 'capybara/rspec'
require 'database_cleaner'

if defined? Rails
  require 'fake_app/rails_app'

  require 'rspec'
  require 'rspec/rails'
  require 'ransack'
end

# Simulate a gem providing a subclass of ActiveRecord::Base before the Railtie is loaded.

require 'active_record'
ACTIVE_RECORD_SCOPE = ActiveRecord::VERSION::MAJOR >= 4 ? :all : :scoped

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
end