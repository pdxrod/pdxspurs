ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'authlogic'
require "authlogic/test_case"
include Authlogic::TestCase
activate_authlogic

require 'webrat'
require 'webrat/core/matchers'
include Webrat::Methods
Webrat.configure do |config|
  config.mode = :rack # not :rails - http://paikialog.wordpress.com/2012/02/11/webrat-no-such-file-to-load-action_controllerintegration/
end

class ActiveSupport::TestCase

  def create_user(options = {}) 
    User.create( { :email => 'juande@spurs.co.uk', :password => User::VALID_PASSWORD, :password_confirmation => User::VALID_PASSWORD, 
                   :secret_word => User::SECRET }.merge( options ) )    
  end

end



