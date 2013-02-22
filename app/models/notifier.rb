# http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic
# is a bit out of date - this I deduced from comments in Rails 4 actionmailer/lib/action_mailer/base.rb 

     class Notifier < ActionMailer::Base
       default :from => 'no-reply@pdxspurs.com', 
               :return_path => 'no-reply@pdxspurs.com'
       default_url_options[:host] = 'pdxspurs.com' 
       
       def password_reset_instructions( recipient )
         
	 @account = recipient
         msg = edit_password_reset_url(recipient.perishable_token)  
         msg = "Click on this URL:\n" + msg

	 mail(:to => recipient.email,
              :subject => "Password reset instructions",
              :body => msg) 
       end

     end


 
