class Api::V1::SessionsController < Devise::SessionsController
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  # skip_before_filter :verify_signed_out_user
  skip_before_action :verify_signed_out_user, :only => [:destroy]
  respond_to :json

  def create
    params[:quiz_user] = eval params[:quiz_user]
    resource = QuizUser.find_for_database_authentication(:email=>params[:quiz_user][:email])

    return invalid_login_attempt unless resource
 
    if resource.valid_password?(params[:quiz_user][:password])
      return unconfirm_login unless resource.confirmed?
      auth_token = resource.ensure_authentication_token
      # sign_in("quiz_user", resource)
      render :json=> {:status=>200, :auth_token=>auth_token, :quiz_user=>resource}
      return
    end
    invalid_login_attempt
  end


  def destroy
      auth_token = Authentication.find_by_auth_token(params[:auth_token])
      current_quiz_user = auth_token.quiz_user
      if current_quiz_user.present?
        auth = current_quiz_user.authentications.find_by_auth_token(params[:auth_token])
        auth.destroy if auth.present?
        current_quiz_user.ensure_authentication_token
        @current_quiz_user = nil
        render :status => 200,
             :json => { :success => true,
                        :info => ["Logged out"],
                        :data => {} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => ["You need to sign in or signup before continuing"],
                      :data => {} }
      end
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => ["Login Failed"],
                      :data => {} }
  end
  protected
  
  def unconfirm_login
    return render :json=> {:success=>false, :message=>"You have to confirm your email address before continuing."}, :status=>401
  end
  
  def invalid_login_attempt
    # warden.custom_failure!
    render :json=> {:success=>false, :message=>"Invalid email or password."}, :status=>401
  end

end