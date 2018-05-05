class CogliAdminController < ApplicationController
  layout 'quiz_admin'
  before_action :authenticate_quiz_admin!
  def index
  end

  def new
  end

  def unfinished_quizzes
    @quizzes = Quiz.where(quiz_status: 'incomplete')
    @quizzes ||=[]
  end
  def submitted_quizzes
    @quizzes = Quiz.where(quiz_status: 'pending')
    @quizzes ||=[]
  end
  def approved_quizzes
    @quizzes = Quiz.where(quiz_status: 'approved')
    @quizzes ||=[]
  end
end
