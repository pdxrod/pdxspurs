require 'spec_helper'

describe "home" do

  it "should see news on home page when not logged in" do
    visit '/logoff'  
    get '/'
    response.body.include?( NEWS_TITLE ).should be_true
  end

  it "should see news on home page when logged in" do
    email = 'me' + Time.now.to_f.to_s.gsub( '.', 'y' ) + '@pdxspurs.com'
    create_user email
    user = User.last
    user.admin?.should be_false
    visit '/login'
    fill_in "user_session_email", :with => user.email
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    get '/'
    response.body.include?( user.name_display ).should be_true
    response.body.include?( NEWS_TITLE ).should be_true
  end

end

