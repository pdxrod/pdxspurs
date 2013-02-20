class PostsController < ApplicationController

  before_filter :require_user

  def save

    params.each do |k, v|
      if v.nil?
        @post = Post.find( params[:id] )
        @post.title = k
        @post.save!
      end

    end
    render :text => "autosaved"
  end

  def index

    @posts = Post.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @posts }
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new

    list_id = params[ 'l' ].to_i
    redirect_to '/lists' and return if list_id < 1 # Nil or complete garbage .to_i is 0 (e.g. /posts/new?l=foobar)
    @post = Post.new
    @post.list_id = list_id
    @post.user_id = current_user.id
                                   
    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end

  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create

    @post = current_user.posts.create( app_params ) 

    respond_to do |format|
      if @post.save
  
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    @post = current_user.posts.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])

        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy

    @post = current_user.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end

 private

  def app_params
    params.require(:post).permit(:title, :message, :list_id, :user_id, :post_id, :image, :width, :height, :updated_at, :created_at)
  end

end
