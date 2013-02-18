class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  validates_presence_of :rolename
  validates_presence_of :user
end


