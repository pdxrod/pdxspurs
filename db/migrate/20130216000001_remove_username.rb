    class RemoveUsername < ActiveRecord::Migration  
      def self.up  

        # email is all that is needed
        remove_column :users, :username

      end  
      
      def self.down  
        add_column :users, :username, :string
      end  
    end  


