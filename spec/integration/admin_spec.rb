require 'spec_helper'

describe "admin" do

  before(:each) do
    2.times { FactoryGirl.create :list }
    visit '/logout'
  end

# This is an answer to the theological problem of the contradiction of omnipotence.
  it "should allow admin to do anything except delete herself" do

    user = User.admin!
    user.admin?.should be_true

    visit '/users/new'

  end

  it "should allow user to do some things but not other things" do

    user = User.last
    user.admin?.should be_false

    visit '/users/new'

  end

end

