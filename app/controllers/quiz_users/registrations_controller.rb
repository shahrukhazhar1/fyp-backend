class QuizUsers::RegistrationsController < Devise::RegistrationsController

  def create
  	super
  end

  def update
  	super
  end

  protected
    def after_update_path_for(resource)
    	flash[:notice]="Password changed successfuly"
    	quiz_creation_index_path
    end

  def after_inactive_sign_up_path_for(resource)
    flash[:notice]="Account created successfully, we have sent you a confirmation email, please log in to your email account and click the confirmation link"
    new_quiz_user_session_path
  end

end