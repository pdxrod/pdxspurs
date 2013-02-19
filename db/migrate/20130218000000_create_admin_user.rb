    class CreateAdminUser < ActiveRecord::Migration  
  
      def self.up  

           User.create!( { :email => User::ADMIN_EMAIL, :password => User::VALID_PASSWORD, 
             :secret_word => User::SECRET, :password_confirmation => User::VALID_PASSWORD } )  

      end  
      
      def self.down  
        
        user = User.find_by_email User::ADMIN_EMAIL
        user.destroy
    
      end  

    end  


