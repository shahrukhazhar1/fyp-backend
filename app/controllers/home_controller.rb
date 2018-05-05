class HomeController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:index]

  before_action :set_session_cookie_if_token_authenticated!, only: [:index]

  before_action :authenticate_user!, :except => [
    :send_report,
    :check_email,
    :check_email_present,
    :check_quiz_user_email,
    :terms_of_service,
    :privacy_policy,
    :privacy_policy_tos
  ]

  if Cogli.force_tutorial?
    before_action :verify_tutorial, :only => [:account, :index]
  end

  def verify_tutorial
    redirect_tutorial_for!(nil)
  end

  def set_session_cookie_if_token_authenticated!
    if request.headers["HTTP_X_USER_EMAIL"].present? &&
        request.headers["HTTP_X_USER_TOKEN"].present? &&
        current_user.present?
      warden.set_user(current_user, scope: :user)
    end
  end

  def send_report
    %x[bundle exec rake send_email]
    render json: "ok", status: :ok
  end

  def index
    @quiz_results = QuizResult
      .joins(:device, [:quiz_selection => :quiz])
      .includes(:device, [:quiz_selection => :quiz])
      .where('devices.user_id = ?', current_user.id)
      .where('quiz_results.created_at >= ?', 7.days.ago)
      .order(created_at: :desc)
  end

  def account
    current_device = nil
    @devices = current_user.devices.order(:created_at)
    @subscription = current_device.subscription if current_device
  end

  def terms_of_service
    redirect_to "privacy_policy_tos"
  end

  def privacy_policy
    redirect_to "privacy_policy_tos"
  end

  def privacy_policy_tos
  end

  def check_email
    if params[:user][:email].present?
      email = User.where(email: params[:user][:email]).last
      if email.present?
        result = false
      else
        result = true
      end
    end
    render :json => result
  end

  def check_email_present
    if params[:user][:email].present?
      email = User.where(email: params[:user][:email]).last
      if email.present?
        result = true
      else
        result = false
      end
    end
    render :json => result
  end
end
