require File.expand_path('../../test_helper', __FILE__)

class BasicLoginTest < ActionDispatch::IntegrationTest 

  def test_should_get_home_page
    get '/'
    assert response.body.include?(          'Log in' )
    assert false == response.body.include?( 'Log out')
  end
  
  def test_should_log_in
   
    @user = create_user
    assert @user.email == JUANDE
    @user = User.find_by_email( JUANDE )
    assert @user.email == JUANDE
   
    visit '/' 
    click_link "Log in"
    fill_in 'user_session_email', :with => @user.email
    fill_in 'user_session_password', :with => User::VALID_PASSWORD
    click_button LOGIN_BUTTON      
    raise response.body unless response.body.include?('Log out')
    assert false == response.body.include?( 'Log in' )

  end

end



