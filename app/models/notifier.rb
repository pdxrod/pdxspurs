# http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic
# is a bit out of date - this I deduced from comments in Rails 4 actionmailer/lib/action_mailer/base.rb 

     class Notifier < ActionMailer::Base
       default :from => 'no-reply@pdxspurs.com', 
               :return_path => 'no-reply@pdxspurs.com'
       default_url_options[:host] = 'pdxspurs.com' 
       
       def password_reset_instructions( recipient )
         Rails.logger.debug "Notifier: Notifier password reset instructions called"
         
	 @account = recipient
         msg = edit_password_reset_url(recipient.perishable_token)  
         msg = "Click here:\n" + msg

	 Rails.logger.debug "Sending to #{recipient.login} Password reset instructions\n#{msg}\n" 
	 
	 mail(:to => recipient.login,
              :subject => "Password reset instructions",
              :body => msg) 
       end

     end


 
