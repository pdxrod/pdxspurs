require 'spec_helper'

describe "messages" do

  before(:each) do
    Post.delete_all
    2.times { FactoryGirl.create :list }
    email = 'me' + Time.now.to_f.to_s.gsub( '.', 'z' ) + '@pdxspurs.com'
    create_user email
    visit '/logoff'
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

  it "should not allow user to add a message without both a title and some contents" do

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

    visit '/lists'
    click_link ADD_MESSAGE # No title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON
    Post.count.should == n 

    visit '/lists'
    click_link ADD_MESSAGE # No message
    fill_in 'post_title', :with => title
    click_button CREATE_BUTTON
    Post.count.should == n 

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
    visit '/lists'
    click_link CREATE_THREAD
    click_button CREATE_BUTTON
    List.count.should == n

    visit '/lists'
    click_link CREATE_THREAD
    fill_in :list_title, :with => title
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
    Post.last.user_id.should == user.id
    Post.all.each { |p| p.user_id.should_not be_nil }

  end

  it "should allow user to comment on a message" do

    user = User.all[ -1 ]
    other = User.all[ 1 ]
    user.admin?.should be_false
    other.admin?.should be_false
    (user == other).should be_false

    word = FactoryGirl.generate :word
    msg = word
    3.times { msg += ' ' + FactoryGirl.generate( :word ) } 
    title = User::LOWER.shuffle 

    visit '/login'
    fill_in "user_session_email", :with => user.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON

    n = Post.count    
    visit '/lists'
    click_link ADD_MESSAGE
    fill_in 'post_title', :with => title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON
    Post.all.each { |p| p.user_id.should_not be_nil }
    parent = Post.last
    parent.title.should == title
    response.body.include?( title ).should be_true
    response.body.include?( word ).should be_true
    visit '/logoff'
 
    visit '/login'
    fill_in "user_session_email", :with => other.email 
    fill_in "user_session_password", :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON
    
    visit '/posts'
    click_link title
    click_link COMMENT
    title.shuffle!
    msg = (User::NUMBERS + User::UPPER).shuffle
    fill_in 'post_title', :with => title
    fill_in 'post_message', :with => msg
    click_button CREATE_BUTTON
    Post.count.should == n + 2
    Post.all.each { |p| p.user_id.should_not be_nil }
    response.body.include?( title ).should be_true
    response.body.include?( msg ).should be_true

    comment = Post.find_by_post_id( parent.id ) 
    comment.title.should == title
    comment.user_id.should == other.id
    parent.user_id.should == user.id

    visit "/posts/#{ comment.id }" # You can't comment on a comment
    response.body.include?( COMMENT ).should be_false
    visit "/posts/#{ comment.id }/edit"
    response.body.include?( COMMENT ).should be_false 

    visit "posts/#{ parent.id }" # The parent post should show its comments
    response.body.include?( title ).should be_true

  end

end


