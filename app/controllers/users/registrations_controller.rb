class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  # current_password なしでプロフィール更新可能
  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :gender, :university, :grade, :faculty, :department, :avatar])
  end

  # 更新後のリダイレクト
  def after_update_path_for(resource)
    mypage_path
  end
end
