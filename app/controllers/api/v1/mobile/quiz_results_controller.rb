class Api::V1::Mobile::QuizResultsController < ApplicationController

  before_action :verify_api_req
  before_action :load_quiz_selection

  def create
    binding.pry
    qr = QuizResult.new
    qr.correct=params[:correct]
    qr.wrong=params[:wrong]
    qr.quiz_user_id = @current_quiz_api_user.id
    qr.quiz_selection_id = @quiz_selection.id
    # render :status => qr.save ? :created : :unprocessable_entity
    if qr.save
      return render :status => 200, :json => { success: true, message: "Quiz Result added successfully" }
    else
      return render :status => 422, :json => { success: false, message: "Can't add Quiz Result"}
    end
  end

  private


    def quiz_result_params
      params.require(:quiz_results).permit!
      # params.require(:quiz_results).permit(:correct, :wrong)
      #   .each_with_object({}) { |(k,v), h| h[k] = v.split(',').map(&:to_i) }
    end

    def load_quiz_selection
      @quiz_selection = @current_quiz_api_user.quiz_selections.find_by(:quiz_id => params[:quiz_id])
    end

end
