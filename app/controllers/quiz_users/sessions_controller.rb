class QuizUsers::SessionsController < Devise::SessionsController
	layout 'quiz_user'
  def new
    super
  end

  def create
    super
  end
  
  def destroy
    super
  end

  protected
  def after_sign_out_path_for(resource_or_scope)
    new_quiz_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    quiz_creation_index_path
  end

end