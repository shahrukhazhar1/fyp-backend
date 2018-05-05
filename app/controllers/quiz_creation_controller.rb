class QuizCreationController < ApplicationController
  layout 'quiz_user'
	before_action :authenticate_quiz_user!
    
  def index
    @quiz_results = current_quiz_user.quizzes.last 10
    @quiz_results ||=[]
  end

  def new
  end

  def edit
  end

  def update
  end
  
  def rejected_quizzes
    @q = current_quiz_user.quizzes.where(quiz_status: 'rejected').ransack(params[:q])
    @quizzes = @q.result(distinct: true)
    @quizzes ||=[]
  end

  def approved_quizzes
    @q = current_quiz_user.quizzes.where(quiz_status: 'approved').ransack(params[:q])
    # @quizzes = @q.result(distinct: true).includes(:grade).joins(:grade)
    if params[:q].present?
      @quizzes = current_quiz_user.quizzes.quiz_with_status('approved',params[:q])
    else
      @quizzes = current_quiz_user.quizzes.where(quiz_status: 'approved')
    end
    @quizzes ||=[]
  end

  def unfinished_quizzes
    @q = current_quiz_user.quizzes.where(quiz_status: 'incomplete').ransack(params[:q])
    @quizzes = @q.result(distinct: true)
    @quizzes ||=[]
  end

  def submitted_quizzes
    @q = current_quiz_user.quizzes.where(quiz_status: 'pending').ransack(params[:q])
    @quizzes = @q.result(distinct: true)
    @quizzes ||=[]
  end

  def tutorials
  end

  

end
