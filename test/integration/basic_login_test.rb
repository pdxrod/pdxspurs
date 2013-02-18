require File.expand_path('../../test_helper', __FILE__)

class BasicLoginTest < ActionDispatch::IntegrationTest 

  def test_should_get_home_page
    get '/'
    assert response.body.include?(          'Log in' )
    assert false == response.body.include?( 'Log out' )
  end
  
  def test_should_log_in
   
    @user = create_user
    assert @user.email == JUANDE
    users = User.find_by_sql( "select distinct * from users where email = '#{JUANDE}'" )
    assert users.size == 1
    @user = users[ 0 ]
    assert @user.email == JUANDE
    
    get '/'
    fill_in 'user_session_email', :with => @user.email
    fill_in 'user_session_password', :with => User::VALID_PASSWORD
    click_link "Log in"
    assert response.body.include?(          'Log out' )
    assert false == response.body.include?( 'Log in' )

  end

end



