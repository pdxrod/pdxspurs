require File.expand_path('../../test_helper', __FILE__)

class BasicLoginTest < ActionDispatch::IntegrationTest 

  def setup
    @user = create_user
  end
  
  def test_should_get_home_page
    get '/'
    assert_response :success
  end
  
  def test_should_log_in

    get '/'
    assert response.body.include?(       'Log in' )
    assert_false response.body.include?( 'Log out' )
    fill_in 'user_session_email', :with => @user.email
    fill_in 'user_session_password', :with => User::VALID_PASSWORD
    click_link "Log in"
    assert response.body.include?(       'Log out' )
    assert_false response.body.include?( 'Log in' )

  end

end



