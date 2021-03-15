class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create destroy]

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash[:success] = "コメントを投稿しました！"
    else
      flash[:alert] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment

  end


  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
