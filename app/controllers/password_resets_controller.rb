# http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic

class PasswordResetsController < ApplicationController  

  before_filter :require_no_user    

  def index
    redirect_to '/'
  end
  
  def edit 
    @token = params[:id]	  

    render  
  end  

  def show  
    load_user_using_perishable_token params[:token]

    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if password.nil?
      password = params[:user][:password]  
      password_confirmation = params[:user][:password_confirmation]  
    end
    @user.password = password
    @user.password_confirmation = password_confirmation
    @user.secret_word = User::SECRET 

    if @user.save  
        flash[:notice] = "Password successfully updated"  
        redirect_to '/'  
    else  
        flash[:notice] = "Error: "+@user.errors.full_messages.join( ' ' )
        render :action => :edit  
    end 
  end 
 
  def new  

    if params[:email].to_s.strip == '' 
      @user = User.new 
      respond_to do |format|
        format.html 
        format.xml { render :xml => @user }
      end
    
    else

      @user = User.find_by_email(params[:email])  
      if @user  
        @user.deliver_password_reset_instructions!  
        flash[:notice] = "Instructions to reset your password have been emailed to you. " +  
                         "Please check your email."  
        redirect_to '/'  
      else  
        flash[:notice] = "No user was found with that email address"  
        render :action => :new  
      end 
    end
 
  end  
 
 private  
  
  def load_user_using_perishable_token( token )  
    @user = User.find_using_perishable_token( token )  

    unless @user  
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
       "If you are having issues try copying and pasting the URL " +  
       "from your email into your browser or restarting the " +  
       "reset password process."  

      redirect_to '/'
    end  

  end

end  


