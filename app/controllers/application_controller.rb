class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :university, :avatar, :grade, :faculty, :department, :gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :university, :avatar, :grade, :faculty, :department, :gender])
    end

    def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
    end
end
