class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  helper 'koudoku/application'

  before_filter :cors_preflight_check
  
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def authenticate_quiz_or_admin_from_token!
    user_token = params[:auth_token]
    auth = user_token && Authentication.find_by_auth_token(user_token.to_s)
    if auth
      if auth.quiz_admin.present? 
        @access_level = "QuizAdmin"
        @current_quiz_admin = auth.quiz_admin
      elsif auth.quiz_user.present?
        @access_level = "QuizUser"
        @current_quiz_user = auth.quiz_user
      end
      true
    else
      render status: 401, json: { success: false, info: "You need to sign in or signup before continuing" }
    end
  end

  def redirect_tutorial_for!(step)
    if params[:tutorial].blank? &&
        !current_user.tutorial_seen.present? &&
        current_user.tutorial_screen != step

      device = current_user.devices.first
      tutorial_steps(device, current_user.tutorial_screen)
      return
    end
  end

  def authenticate_quiz_user_from_token!
    user_token = params[:auth_token]
    user = user_token && Authentication.find_by_auth_token(user_token.to_s)
    if user && user.quiz_user.present?
      @current_quiz_user = user.quiz_user
      true
    else
      render :status => 401, :json => { :success => false, :info => "You need to sign in or signup before continuing" }
    end
  end

  def authenticate_quiz_admin_from_token!
    user_token = params[:auth_token]
    user = user_token && Authentication.find_by_auth_token(user_token.to_s)
    if user && user.quiz_admin.present?
      @current_quiz_admin = user.quiz_admin
      true
    else
      render :status => 401, :json => { :success => false, :info => "You need to sigin to access Admin Portal" }
    end
  end

  def authenticate_any!
    authenticate_quiz_user!
  end

  def current_device
    if current_user
      if params[:owner_id] || params[:device_id]
        id = (params[:owner_id] || params[:device_id])

        if id == 'default'
          @device ||= current_user.devices.first
        else
          @device ||= current_user.devices.find(id)
        end
      else
        @device ||= current_user.devices.first
      end
    end
  end

  helper_method :current_device

  def tutorial_steps(device, tutorial_step)
    if tutorial_step == "step_6"
      flash[:on_tutorial] = 'true'
      redirect_to device_path(device, tutorial:true) and return
    elsif tutorial_step == "step_5"
      flash[:on_tutorial] = 'true'
      redirect_to quiz_shopping_device_path(device,tutorial:true) and return
    elsif tutorial_step == "step_4"
      flash[:on_tutorial] = 'true'
      redirect_to quiz_queue_device_path(device,tutorial:true) and return
    elsif tutorial_step == "step_2"
      flash[:on_tutorial] = 'true'
      redirect_to koudoku.owner_subscriptions_path(current_device,tutorial:true) and return
    elsif tutorial_step == "step_1"
      flash[:on_tutorial] = 'true'
      redirect_to edit_device_path(device,tutorial:true) and return
    end
  end
end
