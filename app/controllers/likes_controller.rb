class LikesController < ApplicationController
  before_action :set_params

  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    @like.save
  end
  
  def destroy
    @like = Like.find_by(post_id: @post.id, user_id: current_user.id)
    @like.destroy
  end
  
  private
  
  def set_params
    @post = Post.find(params[:post_id])
  end
end
