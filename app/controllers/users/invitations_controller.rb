class Users::InvitationsController < Devise::InvitationsController

  protected

  # invite_resource is called when creating invitation
  # should return an instance of resource class

  # this is devise_invitable's implementation
  # def invite_resource(&block)
  #   resource_class.invite!(invite_params, current_inviter, &block)
  # end

  def after_invite_path_for(resource)
    dashboard_path
  end

  def invite_resource(&block)
    @user = Consumer.find_by(email: invite_params[:email])
    # @user is an instance or nil
    if @user && @user.email != current_user.email
      # invite! instance method returns a Mail::Message instance
      @user.invite!(current_user)
      # return the user instance to match expected return type
      @user
    else
      # invite! class method returns invitable var, which is a User instance
      resource_class.invite!(invite_params, current_inviter, &block)
    end
  end
end
