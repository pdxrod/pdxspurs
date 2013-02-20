require 'spec_helper'

describe "messages" do

  before(:each) do
    2.times { FactoryGirl.create :list }
    email = 'me' + Time.now.to_f.to_s.gsub( '.', 'z' ) + '@pdxspurs.com'
    create_user email
    visit '/logout'
  end

  it "should allow user to add a thread" do

    user = User.last
    user.admin?.should be_false
    title = random_message

    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    
    n = List.count
    visit '/lists/new'
    fill_in 'list_title', :with => title
    click_button CREATE_BUTTON
    List.count.should == n + 1

  end

  it "should allow user to add a message" do

    user = User.last
    user.admin?.should be_false
    msg = ''
    4.times { msg += FactoryGirl.generate( :word ) + ' ' } 
    title = random_message

    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    
    n = Post.count
    visit '/posts/new'
    response.body.include?( 'post_title' ).should be_false # You have to choose a list before posting a post

    visit '/lists'
    click_link ADD_MESSAGE
    fill_in 'post_title', :with => title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON
    Post.count.should == n + 1

  end

end

