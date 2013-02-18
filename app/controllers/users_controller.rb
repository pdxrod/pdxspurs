class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  before_filter :require_admin, :only => :index

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])

    unless can_change?( @user )

      flash[ :notice ] = MUST_BE_USER
      redirect_to( '/' )

    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to('/', :notice => "You are now signed up and logged on as #{ @user.email }") }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        errs = 'Not signed up: ' + flash_errs( @user )
        flash[:notice] = errs
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    old_password = params[ :user ][ :old_password ]
    params[ :user ].delete :old_password
    @user.errors.add( :password, " - old password must be filled in") if old_password.blank?
    @user.errors.add( :password, " - old password is wrong") unless @user.valid_password?( old_password )
    params[:user][:secret_word] = User::SECRET

    respond_to do |format|
      if @user.errors.empty? and @user.update_attributes(params[:user])
        format.html { redirect_to :users, notice: 'Updated' }
        format.json { head :no_content }
      else
        flash_errs @user
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.admin?
      @user.errors.add( :email, ' - admin user cannot be deleted' )
      flash_errs @user
    else
      @user.destroy     

      respond_to do |format|
        format.html { redirect_to(:users, :notice => 'Deleted') }
        format.json { head :no_content }
      end
    end
  end

end


