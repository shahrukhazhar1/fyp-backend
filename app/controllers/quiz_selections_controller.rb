class QuizSelectionsController < ApplicationController

  before_action :authenticate_user!, :load_device
  before_action :load_quiz_and_quiz_selection, :only => [:change_order, :destroy]

  def index
    @q = Quiz.where.not(id: @device.quizzes.pluck(:id)).ransack(params[:q])
    # @quizzes = @q.result(distinct: true).includes(:grade).joins(:grade)
    @quizzes = @q.result(distinct: true)
  end

  def create
    @device.quizzes << Quiz.find(params[:quizzes])
    flash[:success] = 'New Quizzes added successfully.'
    redirect_to device_quizzes_path(@device, :q => {:s => 'priority ASC'})
  end

  def change_order
    @quiz_selection.change_order params[:move].to_i
    redirect_to [@device, :quizzes, :q => {:s => 'priority ASC'}]
  end

  def destroy
    
    @quiz_selection.active = false

    if @quiz_selection.save
      flash[:success] = "Successfully deleted..."
    else
      flash[:error] = "Could not delete quiz for some reason, try again later."
    end
    redirect_to device_quizzes_path(@device, :q => {:s => 'priority ASC'})
  end

  def selection
    QuizSelection.device_selection(@device.id, params[:quiz_id],params[:removal])
    respond_to do |format|
      format.js
    end
  end

  private

    def load_device
      @device = current_user.devices.find params[:device_id]
    end

    def load_quiz_and_quiz_selection
      @quiz = @device.quizzes.find params[:quiz_id]
      @quiz_selection = @quiz.quiz_selections.find params[:id]
    end

end
