class Users::ConfirmationsController < DeviseController
  # protected
  # def after_confirmation_path_for(resource_name, resource)
  #   profile_after_confirm_path
  # end

  def new
    super
  end

  def create
    super
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      flash[:notice] = "Your email address has been successfully confirmed."
      redirect_to new_user_session_path and return

    elsif resource.confirmed? && resource.errors.present?
      if current_user.present? && current_user.email == resource.email
        flash[:notice] = "Your email address was already confirmed"
        redirect_to root_path and return
      else
        flash[:notice] = "Your email address was already confirmed, please try signing in"
        redirect_to new_user_session_path and return
      end

    else
      flash[:notice] = resource.errors.full_messages.first
      redirect_to new_user_session_path and return
    end
  end


end