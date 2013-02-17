ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webrat'
require 'factory_girl'

class ActiveSupport::TestCase

  def create_user(options = {}) 
    User.create( { :email => 'juande@spurs.co.uk', :password => User::VALID_PASSWORD, :password_confirmation => User::VALID_PASSWORD, 
                   :secret_word => User::SECRET }.merge( options ) )    
  end

end



