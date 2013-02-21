class ListsController < ApplicationController

  before_filter :require_user

  def save

    params.each do |k, v|
      if v.nil?
        @list = List.find( params[:id] )
        @list.title = k
        @list.save!
      end

    end
    render :text => "autosaved"

  end

  def index

    @lists = List.find(:all)

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
    @list = current_user.lists.find(params[:id])
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

    @list = current_user.lists.find(params[:id])
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



