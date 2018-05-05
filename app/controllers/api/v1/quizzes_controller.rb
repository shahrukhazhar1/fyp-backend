class Api::V1::QuizzesController < ApplicationController

  # before_action :authenticate_quiz_user_from_token!, :except => [:update_row_order]

  before_action :authenticate_quiz_or_admin_from_token!, :except => [:update_row_order, :set_sample_question]


  before_action :load_quiz, :except => [:update_grades, :add_grades, :set_sample_question, :get_grades, :index, :all_quizzes, :new, :create,:update_row_order]

  before_action :quiz_user_access, except: [:set_sample_question, :create, :get_grades]

  before_action :check_approve, only: [:edit, :update]

  before_action :check_edit, only: [:edit, :update]


  def destroy
    if @quiz.present? && @quiz.destroy
      return render :status => 200, :json => { success: true }
    else
      retrun render :status => 200, :json => { success: false }
    end
  end
  
  def set_comment
    if @quiz.present?      
      comment = Comment.new

      if params[:user_type] == "admin"
        comment.posted_by = "admin"
        comment.quiz_admin_id = params[:quiz_admin_id]
        if Rails.env.production?
          quiz_url = "#{Rails.configuration.quiz_creation_url}/quizzes/#{@quiz.id}"
        else
          quiz_url = "http://localhost:5001/quizzes/#{@quiz.id}"
        end
        if @quiz.quiz_user.email_alert.present?
          SendEmails.send_notif(@quiz.quiz_user.email,"View Admin Comment",quiz_url).deliver!
        end
      else
        comment.posted_by = "quizuser"
        comment.quiz_user_id = params[:quiz_user_id]
      end
      
      comment.text = params[:chat_text]
      comment.quiz_id = @quiz.id
      comment.save
      
      return render :status => 200, :json => { success: true, quiz: @quiz }
    else
      return render :status => 404, :json => { success: false }
    end
  end

  def set_sample_question
    question = Question.find_by_id params[:question_id]
    if question.present?
      quiz = question.quiz
      quiz.questions.each do |q|
        q.update_attribute(:sample,false)  
      end
      question.update_attribute(:sample, true)
    else
      return render :status => 404, :json => { success: false }
    end
    return render :status => 200, :json => { success: true }
  end

  def get_grades
    render :status => 200, :json => { success: true, grades: Grade.all, courses: Course.all }
  end

  def new_verison
    @quiz = Quiz.find_by_id params[:id]
    
    name = @quiz.try(:name) + " V2"

    @quiz_new = Quiz.new

    @quiz_new.name = name

    @quiz_new.subject = @quiz.subject

    @quiz_new.quiz_user_id = @quiz.quiz_user_id

    @quiz_new.description = @quiz.description

    @quiz_new.study_guide_text = @quiz.study_guide_text

    @quiz_new.study_guide_comment = @quiz.study_guide_comment

    @quiz_new.passing_percentage = @quiz.passing_percentage

    @quiz_new.topic = @quiz.topic

    @quiz_new.test_prep = @quiz.test_prep

    @quiz_new.save!
    
    @quiz.questions.each do |qs|
      q1 = @quiz_new.questions.new  
      q1.text = qs.text
      q1.hint = qs.hint
      q1.save(validate: false)
      qs.answers.each do |a|
        a1 = q1.answers.new
        a1.text = a.text
        a1.correct = a.correct
        a1.correct = a.correct
        a1.save(validate: false)
      end  
    end 
    if @quiz.grades.present?
      @quiz.grades.each do |grade|
        quiz_grade = QuizGrade.new
        quiz_grade.quiz_id = @quiz_new.id
        quiz_grade.grade_id = grade.id
        quiz_grade.save
      end
    end
    # redirect_to edit_quiz_path(@quiz_new)
    return render :status => 200, :json => { success: true, quiz_revise: @quiz_new }

  end

  def study_guide
    if params[:study_text] || params[:study_comment].present?
      @quiz.study_guide_text = params[:study_text]
      @quiz.study_guide_comment = params[:study_comment]
      @quiz.save!
    end
    return render :status => 200, :json => { success: true, quiz: @quiz }
  end

  def submit_for_approval
    @quiz.quiz_status = "pending"
    @quiz.save!
    return render :status => 200, :json => { success: true, quiz: @quiz }
  end


  def index
    # @q = @device.quiz_selections.ransack(params[:q])
    # @quizzes = @q.result(distinct: true).includes(:quiz => :grade).joins(:quiz => :grade)
    @q = Quiz.all.ransack(params[:q])
    # @quizzes = @q.result(distinct: true).includes(:grade).joins(:grade)
    @quizzes = @q.result(distinct: true)
    
  end

  def all_quizzes
    @quizzes = QuizSelection.joins(:device).where('devices.user_id = ?', current_user.id)
      .includes(:device, :quiz => :grade).order('quiz_selections.created_at DESC')
  end

  def new
    @quiz = Quiz.new
  end

  def update_grades
    @quiz = Quiz.find_by_id params[:quiz_id]

    if params[:grade_all]
      @quiz.quiz_grades.destroy_all
      s = params[:grade_all].count - 1
      for i in 0..s
        quiz_grade = QuizGrade.new
        quiz_grade.quiz_id = @quiz.id
        quiz_grade.grade_id = params[:grade_all][i]
        quiz_grade.save
      end
    end
    return render :status => 200, :json => { success: true, quiz: @quiz }
  end

  def add_grades
    @quiz = Quiz.find_by_id params[:quiz_id]
    if params[:grade_all]
      s = params[:grade_all].count - 1
      for i in 0..s
        quiz_grade = QuizGrade.new
        quiz_grade.quiz_id = @quiz.id
        quiz_grade.grade_id = params[:grade_all][i]
        quiz_grade.save
      end
    end
    return render :status => 200, :json => { success: true, quiz: @quiz }
  end
  
  def create
    quiz_user = @current_quiz_user
    
    if params[:quiz].is_a?(String)
      params[:quiz] = eval params[:quiz]
    end
    
    @quiz = Quiz.new(quiz_params)
    @quiz.quiz_user_id = quiz_user.id
    if @quiz.save
      QuizSelection.quiz_selection(quiz_user.id, @quiz.id)
      
      if params[:grade_all]
        s = params[:grade_all].count - 1
        for i in 0..s
          quiz_grade = QuizGrade.new
          quiz_grade.quiz_id = @quiz.id
          quiz_grade.grade_id = params[:grade_all][i]
          quiz_grade.save
        end
      end
      return render :status => 200, :json => { success: true, quiz: @quiz }
    else
      error_message = ""
      i = 0
      e = @quiz.errors.messages[:name]
      if e
        0.upto(0) do |m|
          error_message = error_message + "Name " + e[m] + "\n"
          i += 1
        end
      end
      e = @quiz.errors.messages[:subject]
      if e
        0.upto(e.length - 1) do |m|
          error_message = error_message + "Subject" + e[m] + "\n"
          i += 1
        end
      end
      if i == 0
        error_message = "Error in creating quiz."
      end
      return render json: { error: error_message.to_json, status: 403 }
    end
  end

  def update
    quiz_user = @current_quiz_user

    if params[:quiz].is_a?(String)
      params[:quiz] = eval params[:quiz]
    end

    if @quiz.update(quiz_params)

      if @current_quiz_user.present? && @quiz.quiz_status == 'rejected'
        @quiz.quiz_status = 'incomplete'
        @quiz.save
      end

      if params[:grade_all]
        
        @quiz.quiz_grades.destroy_all

        s = params[:grade_all].count - 1
        for i in 0..s
          quiz_grade = QuizGrade.new
          quiz_grade.quiz_id = @quiz.id
          quiz_grade.grade_id = params[:grade_all][i]
          quiz_grade.save
        end
      end
      return render :status => 200, :json => { success: true, quiz: @quiz }
    else
      return render :status => 400, :json => { success: false}
    end
  end


  def show
    user = @current_quiz_user
    @questions = @quiz.questions
    render :status => 200, :json => { success: true, quiz: @quiz, questions: @questions, grades: Grade.all, labels: Label.all }
  end

  def edit
    # user = @current_quiz_user
    
    @questions = @quiz.questions
    render :status => 200, :json => { success: true, quiz: @quiz, questions: @questions, grades: Grade.all, labels: Label.all }
  end

  # def update_row_order
  #   @device = current_user.devices.find params[:id]
  #   @thing = Quiz.find(params[:thing][:thing_id])
  #   @thing.row_order_position = params[:thing][:row_order_position]
  #   @thing.save
  #   @quizzes = @device.quizzes.quiz_queue_search(whitelist_search_params).rank(:row_order).page(params[:page]).per(5)
  #   respond_to do |format|
  #     format.js { render :quiz_queue }
  #   end

  #   # render nothing: true
  # end

  def approve
    # quiz_admin = QuizAdmin.find_by_authentication_token params[:auth_token]
    auth_token = Authentication.find_by_auth_token(params[:auth_token])
    quiz_admin = auth_token.quiz_admin
    
    if @quiz.present? && quiz_admin.present?
      @quiz.quiz_status = 'approved'
      @quiz.approval_date = DateTime.now
      @quiz.approved_by = quiz_admin.email
      @quiz.save!
      render status: 200, json: { success: true, quiz: @quiz, questions: @questions, grades: Grade.all }
    else
      render status: 404, json: { success: false, quiz: @quiz, questions: @questions, grades: Grade.all }
    end
  end

  def quiz_results
    render status: 200, json: { success: true, quiz_results: @current_quiz_user.quiz_results }

  end

  def reject
    # quiz_admin = QuizAdmin.find_by_authentication_token params[:auth_token]
    auth_token = Authentication.find_by_auth_token(params[:auth_token])
    quiz_admin = auth_token.quiz_admin
    if @quiz.present? && quiz_admin.present?
      @quiz.quiz_status = 'rejected'
      @quiz.approval_date = nil
      @quiz.approved_by = nil
      @quiz.save!
      render status: 200, json: { success: true, quiz: @quiz, questions: @questions, grades: Grade.all }
    else
      render status: 404, json: { success: false, quiz: @quiz, questions: @questions, grades: Grade.all }
    end
  end

  private

    def quiz_params
      params.require(:quiz).permit :name, :subject, :grade_id, :passing_percentage, :topic, :description, :test_prep, :attachment, :supplement_text, :quiz_guide, :quiz_guide_attachment
    end

    def load_device
      @device = current_user.devices.find params[:device_id]
    end

    def load_quiz
      @quiz = Quiz.find_by_id params[:id]
    end

    def check_approve
      if @quiz.present? && @access_level == 'QuizUser' && @quiz.quiz_status.to_s.downcase == 'approved'
        return render status: 403, json: { success: false, message: 'Quiz is already approved.'}   
      end
    end

    def check_edit
      if @quiz.present? && @access_level == 'QuizUser' && @quiz.quiz_status.to_s.downcase == 'pending'
        return render status: 403, json: { success: false, message: 'Quiz is already submitted.'}   
      end
    end

    def quiz_user_access
      if @quiz.present? && @current_quiz_user.present? && @quiz.quiz_user_id != @current_quiz_user.id
        return render status: 403, json: { success: false, message: 'You can only view quizzes that are created by you.'}   
      end

    end

    def load_quiz_selection
      @quiz_selection = @device.quiz_selections.find_by quiz_id: params[:id]
    end

    def update_pdf_preview(quiz,quiz_params)
    end
end
