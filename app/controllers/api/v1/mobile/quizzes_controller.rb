class Api::V1::Mobile::QuizzesController < ApplicationController
  before_action :verify_api_req
  before_action :load_quiz, :except => [:index, :new, :create, :api_quiz_results]
  

  def index
    @quizzes = @current_quiz_api_user.quizzes
    return render :status => 200, :json => { success: true, quizzes: @quizzes }
  end


  def show
    render :status => 200, :json => { success: true, quiz: @quiz }
  end

  def api_quiz_results
    render status: 200, json: { success: true, quiz_results: @current_quiz_api_user.quiz_results }

  end

  

  private

    def load_quiz
      @quiz = Quiz.find_by_id params[:id]
    end
end