class Users::RegistrationsController < Devise::RegistrationsController  
  # prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  # prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  # prepend_before_action :set_minimum_password_length, only: [:new, :edit]

  before_action :configure_permitted_parameters, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def create
    build_resource (user_params)
    begin
      if resource.errors.blank?
        resource.save!
        flash[:notice]="Account created successfully, we have sent you a confirmation email, please log in to your email account and click the confirmation link"
        sign_in(resource_name, resource)
        redirect_to home_path
      else
        clean_up_passwords resource
        set_minimum_password_length
        # respond_with resource
        resource.errors.full_messages.each {|x| flash[:alert] = x}
        redirect_to new_user_session_path
      end
    rescue
      resource.errors.full_messages.each {|x| flash[:alert] = x}
      redirect_to new_user_session_path
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      resource.errors.full_messages.each {|x| flash[:alert] = x}
      redirect_to account_path
    end
  end

  private

  def after_update_path_for(r)
    account_path
  end

  def user_params
    params.require(:user).permit!
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :email,
        :first_name,
        :last_name,
        :password,
        :password_confirmation
      ]
    )
  end
end
