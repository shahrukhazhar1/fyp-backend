class Api::V1::UsersController < ApplicationController
  before_action :authenticate_quiz_user_from_token!

  def update_password
    params[:quiz_user] = eval params[:quiz_user]
    
    auth_token = Authentication.find_by_auth_token(params[:auth_token])
    
    @user = auth_token.quiz_user

    if @user
      unless @user.valid_password?(params[:quiz_user][:current_password]) || @user.valid_password?(params[:quiz_user][:current_password_confirmation])
        return passwords_not_match
      end
      @user.update_attributes(password: params[:quiz_user][:password], password_confirmation: params[:quiz_user][:password_confirmation] )
      respond_to do |format|
        format.json {  render :json => {:success=>true, :status=>200} }
      end
    end
  end 
  protected
  
  def passwords_not_match
    # warden.custom_failure!
    render :json=> {:status=>403, :success=>false, :message=>"Your current password is invalid."}
  end

end