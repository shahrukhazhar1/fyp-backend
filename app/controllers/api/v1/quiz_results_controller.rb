class Api::V1::QuizResultsController < Api::V1::ApiController

  before_action :load_device_and_quiz_selection

  def create
    @quiz_result = @device.quiz_results.build(quiz_result_params.merge({quiz_selection_id: @quiz_selection.id}))
    render :status => @quiz_result.save ? :created : :unprocessable_entity
  end

  private


    def quiz_result_params
      params.require(:quiz_result).permit(:correct, :wrong)
        .each_with_object({}) { |(k,v), h| h[k] = v.split(',').map(&:to_i) }
    end

    def load_device_and_quiz_selection
      @device = current_user.devices.find(params[:device_id])
      @quiz_selection = @device.quiz_selections.find_by(:quiz_id => params[:quiz_id])
    end

end
