    class CreateAdminRole < ActiveRecord::Migration  
  
      def self.up  

         role = Role.create!( { :rolename => User::ADMIN } )
         admin = User.find_by_email( User::ADMIN_EMAIL )
         if admin.nil?
           admin = User.create!( { :email => User::ADMIN_EMAIL, :password => User::VALID_PASSWORD, 
                     :secret_word => User::SECRET, :password_confirmation => User::VALID_PASSWORD } ) 
         end
         admin.roles << role

      end  
      
      def self.down  
        
        role = Role.find_by_rolename( User::ADMIN )
        admin = User.find_by_email( User::ADMIN_EMAIL )
        admin.roles.delete role 
        role.destroy
    
      end  

    end  


