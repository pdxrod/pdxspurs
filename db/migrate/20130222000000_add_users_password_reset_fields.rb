# http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic

class AddUsersPasswordResetFields < ActiveRecord::Migration

  def self.up
    add_column :users, :perishable_token, :string, :default => "", :null => false
    add_index :users, :perishable_token
  end

  def self.down
    remove_column :users, :perishable_token
  end

end


