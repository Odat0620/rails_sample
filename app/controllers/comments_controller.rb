class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash[:success] = "コメントを投稿しました！"
    else
      flash[:alert] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
      flash[:success] = "コメントを削除しました。"
    end
    redirect_to post_path(params[:post_id])
  end


  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
