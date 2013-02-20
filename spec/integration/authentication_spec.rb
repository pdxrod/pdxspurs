require 'spec_helper'

describe "authlogic" do

  before(:each) do
    User.delete_all

    2.times do
      email = 'me' + Time.now.to_f.to_s.gsub( '.', 'x' ) + '@pdxspurs.com'
      create_user email
    end

    visit '/logout'
  end

  it "should register new user using any of the captcha words but not otherwise" do

    n = User.count
    User::WORDS.each do |secret|
      register_user( secret, n, true )
      n += 1
    end
    n = User.count
    register_user( User::INVALID_EMAIL_PASSWORD_OR_SECRET, n, false )

  end

  it "should not register new user with invalid password" do
    visit '/logout'

    user = FactoryGirl.build :user

    n = User.count

    visit "/users/new"
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => User::INVALID_EMAIL_PASSWORD_OR_SECRET
    fill_in "user_password_confirmation", :with => User::INVALID_EMAIL_PASSWORD_OR_SECRET
    fill_in "user_secret_word", :with => User::SECRET

    click_button SIGNUP_BUTTON
    User.count.should == n
  end

  it "should not register new user without matching password & confirmation" do
    visit '/logout'

    user = FactoryGirl.build :user

    n = User.count

    visit "/users/new"
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => User::VALID_PASSWORD
    fill_in "user_password_confirmation", :with => User::VALID_PASSWORD + '!'
    fill_in "user_secret_word", :with => User::SECRET

    click_button SIGNUP_BUTTON 
    User.count.should == n
  end

  it "should not register new user with invalid email" do
    visit '/logout'

    n = User.count

    visit "/users/new"
    fill_in "user_email", :with => User::INVALID_EMAIL_PASSWORD_OR_SECRET
    fill_in "user_password", :with => User::VALID_PASSWORD
    fill_in "user_password_confirmation", :with => User::VALID_PASSWORD
    fill_in "user_secret_word", :with => User::SECRET

    click_button SIGNUP_BUTTON 
    User.count.should == n
  end

  it "should log on" do
    user = User.last
    user.admin?.should be_false
    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    get '/posts/new'
    response.body.include?( 'name="post[title]"' ).should be_true # You are on the new message form
    response.body.include?( 'user_sessions/new' ).should be_false # Message saying you are being redirected to login page
  end

  it "should not log on with invalid password" do
    user = User.last
    user.admin?.should be_false
    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::INVALID_EMAIL_PASSWORD_OR_SECRET
    click_button LOGIN_BUTTON
    get '/posts/new'
    response.body.include?( 'name="post[title]"' ).should be_false
    raise response.body unless response.body.include?( 'user_sessions/new' )
  end

  it "should not log on with invalid email" do
    user = User.last
    user.admin?.should be_false
    visit '/login'
    fill_in "user_session_email", :with => User::INVALID_EMAIL_PASSWORD_OR_SECRET
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    get '/posts/new'
    response.body.include?( 'name="post[title]"' ).should be_false
    response.body.include?( 'user_sessions/new' ).should be_true
  end

end

