class PostsController < ApplicationController
  ajax_respond :section_id => 'page', :only => "index" # tests that :only option is not excluding index action
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.published.order('published_at DESC').paginate(:page => params[:page], :per_page => 3)
    @upcomingposts = Post.unpublished.order('published_at ASC').paginate(:page => params[:upcomingpage], :per_page => 2)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
      ajax_respond format, :section_id => :upcomingpage
      ajax_respond format, :section_id => "global", :render => { :layout => "ajax" }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    redirect_to posts_url, :alert => "Access Denied" and return if !session[:admin]
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    redirect_to post_url(params[:id]), :alert => "Access Denied" and return if !session[:admin]
    @post = Post.find(params[:id])
    @post.published_at = @post.created_at if @post.published_at.nil?
  end

  # POST /posts
  # POST /posts.json
  def create
    redirect_to posts_url, :alert => "Access Denied" and return if !session[:admin]
    @post = Post.new(params[:post])
    @post.published_at = @post.created_at if @post.published_at.nil?

    respond_to do |format|
      if @post.save
        @post.published_at = @post.created_at if @post.published_at.nil?
        @post.save
        format.html { redirect_to @post, :notice => 'Post was successfully created.' }
        format.json { render :json => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    redirect_to post_url(params[:id]), :alert => "Access Denied" and return if !session[:admin]
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    redirect_to post_url(params[:id]), :alert => "Access Denied" and return if !session[:admin]
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, :notice => "Post destroyed." }
      format.json { head :no_content }
    end
  end
end
