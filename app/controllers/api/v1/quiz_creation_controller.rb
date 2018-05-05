class Api::V1::QuizCreationController < ApplicationController
  # layout 'quiz_user'
	# before_action :authenticate_quiz_user!
  before_action :authenticate_quiz_user_from_token!

  def quiz_messages
    user = @current_quiz_user
    quizzes = user.quizzes.includes(:comments).where.not(comments: { quiz_id: nil })
    render :status => 200, :json => { success: true, quizzes: quizzes }
  end

  def user_info
    user = @current_quiz_user
    render :status => 200, :json => { success: true, quiz_user: user }
  end

  def set_switch_val
    user = @current_quiz_user
    user.email_alert = params[:switch_val]
    user.save
    render :status => 200, :json => { success: true }
  end

  def index
    user = @current_quiz_user
    quiz_results = user.quizzes.last 10
    quiz_results ||=[]
    render :status => 200, :json => { success: true, quizzes: quiz_results }
  end

  def new
  end

  def edit
  end

  def update
  end
  
  def rejected_quizzes
    user = @current_quiz_user
    @quizzes = user.quizzes.where(quiz_status: 'rejected')
    @quizzes ||=[]
    render :status => 200, :json => { success: true, rejected_quizzes: @quizzes }
  end

  def approved_quizzes
    user = @current_quiz_user
    # params[:q] = eval params[:q]
    if params[:q].present?
      @quizzes = user.quizzes.quiz_with_status('approved',params[:q])
    else
      @quizzes = user.quizzes.where(quiz_status: 'approved')
    end
    @quizzes ||=[]
    render :status => 200, :json => { success: true, grades: Grade.all ,approved_quizzes: @quizzes }
  end

  def unfinished_quizzes
    user = @current_quiz_user
    @quizzes = user.quizzes.where(quiz_status: 'incomplete')
    @quizzes ||=[]
    render :status => 200, :json => { success: true, unfinished_quizzes: @quizzes }
  end

  def submitted_quizzes
    user = @current_quiz_user
    @quizzes = user.quizzes.where(quiz_status: 'pending')
    @quizzes ||=[]
    render :status => 200, :json => { success: true, submitted_quizzes: @quizzes }
  end

  def tutorials
  end

end