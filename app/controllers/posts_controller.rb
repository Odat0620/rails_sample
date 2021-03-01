class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_post, only: %i[edit show update destroy]

  def index
    @user = current_user
    @search = Post.search(params[:q])
    @posts = @search.result.includes(:user).order("created_at DESC").page(params[:page]).per(20)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path, notice: '投稿しました。'
    else
      flash.now[:alert] = "文字数を確認してください。"
      render :new
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy if post.user_id == current_user.id
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post.update(post_params) if @post.user_id == current_user.id.order("created_at DESC").page(params[:page]).per(20)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
  end

  def show_posts
    @user = current_user
    @posts = Post.where(user_id: @user.id).all.order("created_at DESC").page(params[:page]).per(20)
  end

  private
    def post_params
      params.require(:post).permit(:title, :content)
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
