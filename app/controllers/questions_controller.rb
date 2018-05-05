class QuestionsController < ApplicationController

  before_action :authenticate_user!, :load_device_and_quiz
  # before_action :load_quiz_selection, :only => [:new, :create, :show, :edit]
  
  # before_action :authenticate_quiz_user!

  # before_action :authenticate_any!


  # before_action :load_device_and_quiz, :except => [:create]
  before_action :load_device_and_quiz
  before_action :load_question, :except => [:new, :create]

  def new
    @question = Question.new
    @question.answers.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      flash[:success] = "Question for '#{@quiz.name}'' created successfully."
      redirect_to [@quiz, @question]
    else
      render :new
    end
  end

  def show
  end

  def change_order
    @question.change_order params[:move].to_i
    redirect_to [@device, @quiz]
  end

  def edit
  end

  def update
    if @question.update question_params
      flash[:success] = "Question updated successfully."
      redirect_to [@device, @quiz, @question]
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = "Question deleted successfully..."
    else
      flash[:error] = "Could not delete question for some reason, Try again later."
    end
    redirect_to [@device, @quiz]
  end

  private

    def question_params
      params.require(:question).permit :text, :hint,:comment, :answers_attributes => [:id, :text, :correct, :_destroy]
    end

    def load_device_and_quiz
      # @device = current_user.devices.find params[:device_id]
      # @quiz = @device.quizzes.find params[:quiz_id]
      @quiz = Quiz.find params[:quiz_id]
    end

    def load_question
      @question = @quiz.questions.find params[:id]
    end

    def load_quiz_selection
      
      # @quiz_selection = @device.quiz_selections.find_by quiz_id: params[:quiz_id]
    end
end
