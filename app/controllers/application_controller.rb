require File.dirname( __FILE__ ) + '/../helpers/application_helper'

class ApplicationController < ActionController::Base

  protect_from_forgery

  helper_method :current_user_session, :current_user

  GUARDIAN_API_KEY = 'djpscrgpj5bcvse97bkbnhxv'

  def require_admin
    flash[ :notice ] = '' 
    user = (! current_user.nil?)
    admin = false
    if user
      admin = true if current_user.admin?
    end
    unless admin
      store_location
      flash[:notice] = MUST_BE_ADMIN
      redirect_to new_user_session_url
    end
    admin
  end

  def require_user
    flash[ :notice ] = '' 
    unless current_user
      store_location
      flash[:notice] = MUST_BE_USER
      redirect_to new_user_session_url
      false
    end
    true
  end

  def require_no_user
    flash[ :notice ] = '' 
    if current_user
      store_location
      flash[:notice] = ""
      redirect_back_or_default( '/' )
      false
    end
    true
  end

  def store_location
#    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

 private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

end



