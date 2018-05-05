class QuizzesController < ApplicationController

  before_action :authenticate_user!
  # before_action :authenticate_quiz_user!

  # before_action :authenticate_any!, :except => [:update_row_order]

  # before_action :load_device, :except => [:all_quizzes,:update_row_order]
  before_action :load_quiz, :except => [:index, :all_quizzes, :new, :create,:update_row_order]
  # before_action :load_quiz_selection, :only => [:show]

  def new_verison
    @quiz_new = Quiz.new
    
    name = @quiz.try(:name) + " V2"

    @quiz_new = Quiz.new

    @quiz_new.name = name

    @quiz_new.subject= @quiz.subject

    @quiz_new.quiz_user_id=@quiz.quiz_user_id

    @quiz_new.description = @quiz.description

    @quiz_new.study_guide_text = @quiz.study_guide_text

    @quiz_new.study_guide_comment = @quiz.study_guide_comment

    @quiz_new.passing_percentage = @quiz.passing_percentage

    @quiz_new.topic = @quiz.topic

    @quiz_new.save!
    
    @quiz.questions.each do |qs|
      q1 = @quiz_new.questions.new  
      q1.text = qs.text
      q1.hint = qs.hint
      q1.save(:validate=>false)
      qs.answers.each do |a|
        a1 = q1.answers.new
        a1.text = a.text
        a1.correct = a.correct
        a1.correct = a.correct
        a1.save(:validate=>false)
      end  
    end 
    redirect_to edit_quiz_path(@quiz_new)

  end

  def study_guide
    if params[:study_text] || params[:study_comment].present?
      @quiz.study_guide_text = params[:study_text]
      @quiz.study_guide_comment = params[:study_comment]
      @quiz.save!
      flash[:notice]="Study Guide Save"
      redirect_to quiz_path(@quiz)
    end
  end

  def submit_for_approval
    @quiz.quiz_status = "pending"
    @quiz.save!
    flash[:notice]="Quiz submitted for Admin Approval"
    redirect_to :back
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

  def create
    @quiz = Quiz.new(quiz_params)
    # @quiz.quiz_user_id = current_quiz_user.id
    if @quiz.save
      # @quiz.quiz_selections.create :device => @device, :owner => true
      # flash[:success] = "Quiz for '#{@device.name}'' created successfully."
      if params[:grade_all]
        s = params[:grade_all].count - 1
        for i in 0..s
          quiz_grade = QuizGrade.new
          quiz_grade.quiz_id = @quiz.id
          quiz_grade.grade_id = params[:grade_all][i]
          quiz_grade.save
        end
      end

      flash[:success] = "Quiz created successfully."
      # redirect_to new_quiz_question_path(@quiz)
      redirect_to root_path
      # redirect_to [@device, @quiz]
    else
      redirect_to root_path
      # render :new
    end
  end

  def update
    if @quiz.update(quiz_params)
      flash[:success] = "Quiz updated successfully."
      redirect_to [@quiz]
    else
      render :edit
    end
  end

  def show
    @questions = @quiz.questions
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
    if @quiz.present?
      @quiz.quiz_status = 'approved'
      @quiz.approval_date = DateTime.now
      @quiz.approved_by = current_quiz_admin.email
      @quiz.save!
      flash[:notice]="Quiz Approved"
    end
    redirect_to :back
  end

  def reject
    if @quiz.present?
      @quiz.quiz_status = 'rejected'
      @quiz.save!
      flash[:notice]="Quiz Rejected"
    end
    redirect_to :back
  end

  private

    def quiz_params
      params.require(:quiz).permit :name, :subject, :grade_id, :passing_percentage, :topic, :description, :test_prep, :attachment
    end

    def load_device
      @device = current_user.devices.find params[:device_id]
    end

    def load_quiz
      # @quiz = @device.quizzes.find params[:id]
      @quiz = Quiz.find params[:id]
    end

    def load_quiz_selection
      @quiz_selection = @device.quiz_selections.find_by quiz_id: params[:id]
    end

end
