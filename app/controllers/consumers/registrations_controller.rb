module Consumers
  class RegistrationsController < Devise::RegistrationsController
 
    def update
      if current_user.authorizations.any?
        # required for settings form to submit when password is left blank
        clean_password if params[:consumer][:password].blank?
        clean_current_password
        @user = Consumer.find(current_user.id)

        if @user.update_attributes(account_update_params)
          set_flash_message :notice, :updated
          # Sign in the user bypassing validation in case his password changed
          sign_in @user, :bypass => true
          redirect_to after_update_path_for(@user)
        else
          render 'edit'
        end
      else
        super
      end
    end

    private

    def clean_password
      params[:consumer].delete('password')
      params[:consumer].delete('password_confirmation')
    end

    def clean_current_password
      params[:consumer].delete('current_password')
    end
  end
end
