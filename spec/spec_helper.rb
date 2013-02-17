ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'webrat'
require 'webrat/core/matchers'
include Webrat::Methods
Webrat.configure do |config|
  config.mode = :rack # not :rails - http://paikialog.wordpress.com/2012/02/11/webrat-no-such-file-to-load-action_controllerintegration/
end

require 'authlogic'
require "authlogic/test_case"
include Authlogic::TestCase
activate_authlogic

require File.expand_path("../../app/helpers/application_helper", __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

end


