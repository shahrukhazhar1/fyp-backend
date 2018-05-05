class Api::V1::QuestionsController < ApplicationController

  # before_action :authenticate_user!, :load_device_and_quiz
  # before_action :load_quiz_selection, :only => [:new, :create, :show, :edit]

  # before_action :authenticate_quiz_user!


  # before_action :load_device_and_quiz, :except => [:create]
  
  before_action :authenticate_quiz_or_admin_from_token!
  before_action :load_device_and_quiz
  before_action :load_question, :except => [:new, :create]
  before_action :quiz_user_access, except: [:set_question_comment]
  before_action :verify_quiz, only: [:edit, :update]
  def set_question_comment
    if @question.present?      
      comment = Comment.new

      if params[:user_type] == "admin"
        comment.posted_by = "admin"
        comment.quiz_admin_id = params[:quiz_admin_id]
      else
        comment.posted_by = "quizuser"
        comment.quiz_user_id = params[:quiz_user_id]
      end
      
      comment.text = params[:chat_text]
      comment.question_id = @question.id
      comment.save
      
      return render :status => 200, :json => { success: true, question: @question, quiz: @quiz }
    else
      return render :status => 404, :json => { success: false }
    end
  end
  
  def new
    @question = Question.new
    @question.answers.build
  end

  def create
    if params[:question].is_a?(String)
      params[:question] = eval params[:question]
    end
    @quiz = Quiz.find_by_id params[:quiz_id]
    @question = @quiz.questions.build(question_params)
    
    if @question.save

      if params[:label_all]
        s = params[:label_all].count - 1
        for i in 0..s
          question_label = QuestionLabel.new
          question_label.question_id = @question.id
          question_label.label_id = params[:label_all][i]
          question_label.save
        end
      end



      update_pdf_preview(@question,params[:question])
      render :status => 200, :json => { success: true, quiz: @quiz, question: @question }
    else
      render :status => 403, :json => { success: false, error: 'Question not created' }
    end
  end

  def show
    @quiz = Quiz.find_by_id params[:quiz_id]
    @question = Question.find_by_id params[:id]
    if @question && @quiz
      render :status => 200, :json => { success: true, quiz: @quiz, question: @question, questions: JSON.parse(@quiz.questions.order('id').all.to_json(request_type: "question"))}

    else
      render :status => 404, :json => { success: false, error: 'Question not found' }
    end
  end

  def change_order
    @question.change_order params[:move].to_i
    redirect_to [@device, @quiz]
  end

  def edit
    @quiz = Quiz.find_by_id params[:quiz_id]
    @question = Question.find_by_id params[:id]
    if @question && @quiz
      render :status => 200, :json => { success: true, question_labels: @question.labels.collect(&:name), labels: Label.all, quiz: @quiz, question: @question, questions: JSON.parse(@quiz.questions.order('id').all.to_json(request_type: "question"))}

    else
      render :status => 404, :json => { success: false, error: 'Question not found' }
    end
  end


  def update
    if params[:question].is_a?(String)
      params[:question] = eval params[:question]
    end

    @quiz = Quiz.find_by_id params[:question][:quiz_id]
    @question = Question.find_by_id params[:question][:id]

    if @question.update question_params
      if params[:label_all]
        
        @question.question_labels.destroy_all

        s = params[:label_all].count - 1
        for i in 0..s
          question_label = QuestionLabel.new
          question_label.question_id = @question.id
          question_label.label_id = params[:label_all][i]
          question_label.save
        end
      end
      render :status => 200, :json => { success: true, quiz: @quiz, question: @question }
    else
      render :status => 403, :json => { success: false, error: @question.errors }
    end
  end

  def destroy
    if @quiz.present? && @question.present? && @question.destroy
      return render :status => 200, :json => { success: true, quiz: @quiz }
    else
      retrun render :status => 200, :json => { success: false, quiz: @quiz }
    end
  end

  private

    def question_params
      params.require(:question).permit(
        :id,
        :quiz_id,
        :text,
        :latex,
        :attachment,
        :hint,
        :comment,
        :study_guide,
        :study_guide_attachment,
        :answers_attributes => [
          :id, :text, :correct,
          :latex, :_destroy, :attachment
        ],
      )
    end

    def load_device_and_quiz
      # @device = current_user.devices.find params[:device_id]
      # @quiz = @device.quizzes.find params[:quiz_id]
      @quiz = Quiz.find_by_id params[:quiz_id]
    end

    def load_question
      @question = @quiz.questions.find_by_id params[:id]
    end

    def load_quiz_selection
      # @quiz_selection = @device.quiz_selections.find_by quiz_id: params[:quiz_id]
    end

    def quiz_user_access
      if @quiz.present? && @current_quiz_user.present? && @quiz.quiz_user_id != @current_quiz_user.id
        return render status: 403, json: { success: false, message: 'You can only view quizzes that are created by you.'}   
      end
    end
    
    def verify_quiz
      if @quiz.present? && @access_level == 'QuizUser' && @quiz.quiz_status.to_s.downcase == 'pending'
        return render status: 403, json: { success: false, message: 'Quiz is already submitted.'}   
      end
    end

    def update_pdf_preview(question,question_params)
      params[:question] = question_params
      if question.study_guide_attachment.url.present?
        # question.guide_filename = params[:question][:study_guide_filename]
        question.guide_filename = params[:question][:guide_filename]
        pdf = Magick::ImageList.new(question.study_guide_attachment.url)
        thumb = pdf.scale(300, 300)
        temp_file = Tempfile.new([ 'temp', '.png' ])
        thumb.write(temp_file.path)
        question.question_guide_pdf_preview = temp_file
        question.save
      end
    end
end
