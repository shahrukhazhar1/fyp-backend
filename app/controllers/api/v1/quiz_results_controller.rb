class Api::V1::QuizResultsController < Api::V1::ApiController

  before_action :verify_api_req
  before_action :load_quiz_selection

  def create
    binding.pry
    # @quiz_result = @current_quiz_api_user.quiz_results.build(quiz_result_params.merge({quiz_selection_id: @quiz_selection.id}))


    # render :status => @quiz_result.save ? :created : :unprocessable_entity
  end

  private


    def quiz_result_params
      params.require(:quiz_results).permit!
      # params.require(:quiz_results).permit(:correct, :wrong)
      #   .each_with_object({}) { |(k,v), h| h[k] = v.split(',').map(&:to_i) }
    end

    def load_quiz_selection
      @quiz_selection = @current_quiz_api_user.quiz_selections.find_by(:quiz_id => params[:quiz_results][:quiz_id])
    end

end
