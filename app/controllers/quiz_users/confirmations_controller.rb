class QuizUsers::ConfirmationsController < DeviseController
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
      redirect_to new_quiz_user_session_path
      # set_flash_message(:notice, :confirmed) if is_navigational_format?
      # sign_in(resource_name, resource)
      # respond_with_navigational(resource){ redirect_to confirmation_getting_started_path }
    else
      set_flash_message(:alert, resource.errors.full_messages.first)
      redirect_to new_quiz_user_session_path and return
    end
  end


end