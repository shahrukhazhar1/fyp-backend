class Api::V1::CogliAdminController < ApplicationController
  before_action :authenticate_quiz_admin_from_token!
  
  def quiz_admin_messages
    # user = uizUser.find_by_authentication_token(params[:auth_token])
    quizzes = Quiz.includes(:comments).where.not(comments: { quiz_id: nil })
    render :status => 200, :json => { success: true, quizzes: quizzes }
  end
  def index
  end

  def new
  end

  def unfinished_quizzes
    @quizzes = Quiz.where(quiz_status: 'incomplete')
    @quizzes ||=[]
    render json: { status: 200, unfinished_quizzes: @quizzes}
  end
  def submitted_quizzes
    @quizzes = Quiz.where(quiz_status: 'pending')
    @quizzes ||=[]
    render json: { status: 200, submitted_quizzes: @quizzes}
  end
  def approved_quizzes
    @quizzes = Quiz.where(quiz_status: 'approved')
    @quizzes ||=[]
    render json: { status: 200, approved_quizzes: @quizzes}
  end
end
