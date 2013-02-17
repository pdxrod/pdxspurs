require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
                   
  def test_should_create_user
    n = User.count
    user = create_user
    assert_equal n + 1, User.count
  end

end

