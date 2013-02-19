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

def create_user( email )
  User.create( { :email => email, :password => User::VALID_PASSWORD, 
                     :password_confirmation => User::VALID_PASSWORD,
                               :secret_word => User::SECRET } )
end

def register_user( word, num, success_wanted ) # Does successful and unsuccessful new user registrations
  visit '/logout'
  n = User.count
  user = FactoryGirl.build :user
  User.count.should == n

  visit "/users/new"
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => User::VALID_PASSWORD
  fill_in "user_password_confirmation", :with => User::VALID_PASSWORD
  fill_in "user_secret_word", :with => word
  click_button SIGNUP_BUTTON      # Registering successfully logs you in
  if success_wanted
    User.count.should == num + 1
    response.body.include?( '"/logout"' ).should be_true
    response.body.include?( '"/login"' ).should_not be_true
  else
    User.count.should == num
    response.body.include?( '"/logout"' ).should_not be_true
    response.body.include?( '"/login"' ).should be_true
  end

  visit '/posts/new'
  if success_wanted
    response.body.include?( 'name="post[title]"' ).should be_true
  else
    response.body.include?( 'name="post[title]"' ).should be_false
  end
end

def sign_up_user( *users )
  visit '/logout'
  if users.size > 0
    user = users[ 0 ]
  else
    user = FactoryGirl.build :user
  end

  visit "/users/new"
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => User::VALID_PASSWORD
  fill_in "user_password_confirmation", :with => User::VALID_PASSWORD
  fill_in "user_secret_word", :with => User::SECRET

  click_button LOGIN_BUTTON      # Registering logs you in

  User.find_by_email user.email
end


