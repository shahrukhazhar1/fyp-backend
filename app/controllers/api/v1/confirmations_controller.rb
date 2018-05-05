class Api::V1::ConfirmationsController < DeviseController
  respond_to :json
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
    # self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    resource = QuizUser.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      render :json=> {:status=>200, :success => true }
    else
      render :status => 401, :json => { :success => false, :error => resource.errors.full_messages }
    end
  end


end