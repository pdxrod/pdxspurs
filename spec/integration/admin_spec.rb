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

  it "should only allow admin to delete a message, and its comments should get deleted too" do

    user = User.last
    user.admin?.should be_false
    msg = random_message
    3.times { msg += ' ' + FactoryGirl.generate( :word ) } 
    title = random_message

    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON

    visit '/lists'
    click_link CREATE_THREAD
    fill_in :list_title, :with => title
    click_button CREATE_BUTTON
    title.shuffle!

    n = Post.count
    visit '/lists'
    click_link ADD_MESSAGE
    fill_in 'post_title', :with => title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON
    title.shuffle!
    msg.shuffle!
    visit '/lists'
    click_link ADD_MESSAGE
    fill_in 'post_title', :with => title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON
    p = Post.last
    p.user_id.should == user.id

    visit '/posts'
    response.body.include?( 'value="delete"' ).should be_false
    click_link title
    click_link COMMENT
    title.shuffle!
    msg = (User::LOWER + User::NUMBERS).shuffle
    fill_in 'post_title', :with => title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON

    Post.count.should == n + 3
    n = Post.count 
    posts = Post.find_all_by_user_id( user.id )
    posts.size.should be > 2

    c = Post.last
    c.post_id.should == p.id
    c.user_id.should == user.id
    
    visit '/logout'
    admin = User.admin!
    visit '/login'
    fill_in "user_session_email", :with => admin.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    until n == 0
      visit '/posts'
      click_button "delete"
      n = Post.count
    end # if this avoids an infinite loop, it means deleting a post deletes its comments
     
  end

end

