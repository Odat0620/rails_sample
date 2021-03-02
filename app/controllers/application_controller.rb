class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  #ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    root_path
    #user_path(resource.id) マイページの場合
  end

  #全ユーザーの投稿一覧
  def all_index
    @user = current_user
    @search = Post.search(params[:q])
    @posts = @search.result.includes(:user).order("created_at DESC").page(params[:page]).per(20)
  end


  
  protected

  def configure_permitted_parameters
    added_attrs = [ :email, :name, :password, :password_confirmation, :image ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
