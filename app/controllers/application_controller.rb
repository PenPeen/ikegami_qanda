class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # devise サインイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    questions_index_path
  end

  # devise サインアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # nameをストロングパラメータに追加
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
