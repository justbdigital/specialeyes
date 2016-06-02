class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  after_action :verify_authorized, except: :index, unless: :without_pundit?

  protect_from_forgery with: :exception

  devise_group :user, contains: [:consumer, :pro]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :store_location

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def without_pundit?
    defined? :device_controller?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username,
                                                 :business_name,
                                                 :first_name,
                                                 :last_name,
                                                 :profile_name,
                                                 :phone,
                                                 :postcode,
                                                 :image,
                                                 :remote_image_url,
                                                 :remove_image,
                                                 :female]
    devise_parameter_sanitizer.for(:account_update) << [:username,
                                                        :business_name,
                                                        :first_name,
                                                        :last_name,
                                                        :profile_name,
                                                        :phone,
                                                        :postcode,
                                                        :image,
                                                        :remote_image_url,
                                                        :remove_image,
                                                        :female]
  end

  def user_not_authorized
    respond_to do |format|
      format.html {
        flash[:error] = 'You are not authorized to perform this action.'
        redirect_to(request.referrer || root_path)
      }
      format.js {render text: "alert('You are not authorized to perform this action.');" }
    end
  end

  def store_location
    if params[:controller] == 'bookings'
      session[:user_return_to] = request.fullpath
    end
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to]
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_dashboard_path
    elsif stored_location_for(resource)
      stored_location_for(resource)
    elsif resource.is_a?(Pro)
      dashboard_path
    else
      super
    end
  end
end
