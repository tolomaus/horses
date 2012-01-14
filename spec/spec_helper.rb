# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  Rails.logger = Logger.new(STDOUT)
  ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
  config.before do |m|
     ActiveRecord::Base.logger.debug "==> #{m.example.full_description}"
   end
  config.after do |m|
    exception=m.example.instance_variable_get("@exception")
    if exception
      ActiveRecord::Base.logger.debug "==> test failed:"
      ActiveRecord::Base.logger.debug "#{exception}"
    else
      ActiveRecord::Base.logger.debug "==> OK"
    end
    ActiveRecord::Base.logger.debug ""
   end
end

