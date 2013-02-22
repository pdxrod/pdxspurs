class ListsController < ApplicationController

  before_filter :require_user

  def index

    @lists = List.all.reverse

    respond_to do |format|
      format.html
      format.xml  { render :xml => @lists }
    end

  end

  def new

    @list = List.new
    @list.user_id = current_user.id
                                   
    respond_to do |format|
      format.html
      format.xml  { render :xml => @list }
    end

  end

  def edit
    if current_user.admin?
      @list = List.find( params[:id] )
    else
      @list = current_user.lists.find(params[:id])
    end
  end

  def create

    @list = current_user.lists.create( app_params ) # app_params is a private method: see below - it's a new thing in Rails 4

    respond_to do |format|
      if @list.save
        format.html { redirect_to('/lists') }
        format.xml  { render :xml => @list, :status => :created, :location => @list }
      else
        flash[ :notice ] = @list.errors.full_messages.join( ' ' )
        format.html { render :action => "new" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end

  end

  def update

    @list = current_user.lists.find(params[:id])
    respond_to do |format|
      if @list.update_attributes( app_params )

        format.html { redirect_to(@list) }
        format.xml  { head :ok }
      else
        flash[ :notice ] = @list.errors.full_messages.join( ' ' )
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end

  end

  def destroy

    @list = nil 
    if current_user.admin?
      @list = List.find( params[:id] )
    end # Raises an exception if anyone other than admin tries to delete a thread
    @list.destroy

    respond_to do |format|
      format.html { redirect_to(lists_url) }
      format.xml  { head :ok }
    end

  end

 private

  def app_params
    params.require(:list).permit(:title, :user_id, :updated_at, :created_at)
  end

end



