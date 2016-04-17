class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  devise_group :user, contains: [:consumer, :pro]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username,
                                                 :business_name,
                                                 :first_name,
                                                 :last_name,
                                                 :profile_name,
                                                 :phone,
                                                 :postcode,
                                                 :female]
    devise_parameter_sanitizer.for(:account_update) << [:username,
                                                        :business_name,
                                                        :first_name,
                                                        :last_name,
                                                        :profile_name,
                                                        :phone,
                                                        :postcode,
                                                        :female]
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
    if resource.is_a?(Pro)
      treatments_path
    else
      super
    end
  end
end
