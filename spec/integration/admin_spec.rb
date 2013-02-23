require 'spec_helper'

describe "admin" do

  before(:each) do
    1.times { FactoryGirl.create :admin}
    2.times { FactoryGirl.create :user }
    3.times { FactoryGirl.create :list }
    visit '/logout'
  end

# This is an answer to the theological problem of the contradiction of omnipotence.
  it "should allow admin to do anything except delete herself" do

    user = User.admin!
    user.admin?.should be_true
    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON

    visit '/'
    response.body.include?( '"/users">users' ).should be_true
    visit '/users'
    response.body.include?( user.email ).should be_true
    response.body.include?( 'edit user' ).should be_true

  end

  it "should allow user to do some things but not other things" do

    user = User.last
    user.admin?.should be_false
    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON

    visit '/'
    response.body.include?( '"/users">users' ).should be_false
    visit '/users'
    response.body.include?( user.email ).should be_false
    response.body.include?( 'edit user' ).should be_false

  end

end

