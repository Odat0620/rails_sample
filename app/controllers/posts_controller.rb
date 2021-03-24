class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :current_user_authenticate, only: %i[edit update destroy]

  def index
    all_index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path, notice: '投稿しました！'
    else
      render :new
    end
  end

  def destroy
    @post.destroy if @post.user_id == current_user.id
    redirect_to root_path, notice: '削除しました。'
  end

  def edit
  end

  def update
    @post.update(post_params)
    if @post.save
      redirect_to user_path(@post.user.id), notice: '編集しました'
    else
      render :edit
    end
  end

  def show
    @comment = Comment.new
    @like = Like.new
    @post_comments = @post.comments.includes(:user).order('created_at DESC')
  end

  def show_posts
    @user = current_user
    @posts = Post.where(user_id: @user.id).all.order("created_at DESC").page(params[:page]).per(20)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def current_user_authenticate
    @post = Post.find(params[:id])
    redirect_to root_path, alert: '権限がありません' if @post.user.id != current_user.id
  end
end
