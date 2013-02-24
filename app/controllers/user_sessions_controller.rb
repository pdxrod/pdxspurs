class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  before_filter :require_admin, :only => :index

  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @user_session }
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save
        flash[:notice] = 'Logged in'
        format.html { redirect_to('/', :notice => 'Logged in') }
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        flash[:notice] = 'Not logged in - email or password invalid'
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
   
    respond_to do |format|
      format.html { redirect_to('/', :notice => '') }
      format.xml  { head :ok }
    end
  end

end


