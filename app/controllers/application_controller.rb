class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  devise_group :user, contains: [:consumer, :pro]
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username, :business_name, :first_name, :last_name, :profile_name, :phone, :sex]
    devise_parameter_sanitizer.for(:account_update) << [:username, :business_name, :first_name, :last_name, :profile_name, :phone, :sex]
  end
end
