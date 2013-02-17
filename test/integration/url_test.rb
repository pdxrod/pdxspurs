require File.expand_path('../../test_helper', __FILE__)

class UrlTest < ActionDispatch::IntegrationTest 

  def setup
    create_user
  end
  
  def test_should_get_home_page
    get  '/'
    assert_response :success
  end

end



