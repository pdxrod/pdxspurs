require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
                   
  def test_should_create_user
    n = User.count
    user = create_user
    raise user.errors.full_messages.join( ' ' ) unless n + 1 == User.count
  end

  def test_should_create_admin_user
    n = User.count
    user = create_user( { :email => User::ADMIN_EMAIL } )
    assert_equal n + 1, User.count
    r = Role.count
    u = user.roles.size
    role = Role.new( { :rolename => User::ADMIN } )
    assert_equal r + 1, Rold.count
    user.roles << role
    assert_equal u + 1, user.roles.size
  end

end

