class Api::V1::RegistrationsController < Devise::RegistrationsController
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json
  def create
    params[:quiz_user] = eval params[:quiz_user]
    build_resource quiz_user_params

    if resource.save
      render :status => 200, :json => { :success => true, :info => ["Successfully Registered!"]}
    else
      render :status => :unprocessable_entity, :json => { :success => false, :error => resource.errors.full_messages }
    end
  end
  private
  def quiz_user_params
    params.require(:quiz_user).permit!
  end
end