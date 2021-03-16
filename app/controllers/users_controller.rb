class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :users_posts, only: [:show]

  def index
  end

  def show
  end

  
  private
  
  def users_posts
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id).all.order("created_at DESC").page(params[:page]).per(20)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
