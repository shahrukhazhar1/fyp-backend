class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :verify_signed_out_user
  respond_to :json
  def create
    if params[:user].is_a?(String)
      params[:user] = eval params[:user]
    end
    resource = QuizUser.new quiz_user_params
    resource.confirmed_at = Date.new()
    resource.confirm
    if resource.save
      render :status => 200, :json => { :success => true, :info => ["Successfully Registered!"]}
    else
      render :status => :unprocessable_entity, :json => { :success => false, :error => resource.errors.full_messages }
    end
  end
  private
  def quiz_user_params
    params.require(:user).permit!
  end
end