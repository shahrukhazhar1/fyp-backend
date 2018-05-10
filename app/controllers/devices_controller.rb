require 'fcm'

class DevicesController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [
    :quiz_shopping,
    :new
  ]

  before_action :authenticate_user!
  before_action :load_device, only: [
    :update_row_order,
    :update_quiz_position,
    :show,
    :edit,
    :update,
    :quiz_shopping,
    :quiz_queue,
    :destroy,
    :quiz_results
  ]

  before_action :set_session_cookie_if_token_authenticated!, only: [
    :quiz_shopping,
    :new
  ]

  helper_method :order_by

  def set_session_cookie_if_token_authenticated!
    if request.headers["HTTP_X_USER_EMAIL"].present? &&
        request.headers["HTTP_X_USER_TOKEN"].present? &&
        current_user.present?

      warden.set_user(current_user, scope: :user)
    end
  end

  # if Cogli.force_tutorial?
  #   before_action :verify_tutorial, except: [:update]
  # end

  # def verify_tutorial
  #   if action_name == 'show'
  #     redirect_tutorial_for!("step_6")
  #   elsif action_name == 'quiz_shopping'
  #     redirect_tutorial_for!("step_5")
  #   elsif action_name == 'quiz_queue'
  #     redirect_tutorial_for!("step_4")
  #   else
  #     redirect_tutorial_for!(nil)
  #   end
  # end

  def index
    @devices = current_user.devices.order('created_at DESC')
  end

  def new
    @device = Device.new
    @parent_number = current_user.devices.includes(:emergency_numbers).first.try(:emergency_numbers).try(:first).try(:phone_number)
  end

  def create
    @device = current_user.devices.build(device_params)

    if @device.save
      flash[:success] = 'Device created successfully.'
      redirect_to devices_path
      return
    else
      render :new
    end
  end

  def show
    @quiz_results = @device
      .quiz_results
      .joins(:quiz_selection => :quiz)
      .includes(:quiz_selection => :quiz)
      .where('quiz_results.created_at >= ?', 7.days.ago)
      .order(created_at: :desc)

    counts = @device
      .quiz_results
      .group('created_at::date')
      .order('created_at::date')
      .where('created_at::date >= ?', 7.days.ago)
      .pluck('created_at::date',
             'SUM(coalesce(array_length(correct, 1), 0)) correct_count',
             'SUM(coalesce(array_length(wrong, 1), 0)) wrong_count',
             'COUNT(CASE WHEN passed THEN 1 END) passed_count',
             'COUNT(CASE WHEN NOT passed THEN 1 END) failed_count')

    counts = counts.map do |(date, c_count, w_count, p_count, f_count)|
      {label: date.to_date.to_s(:short),
       datum: [c_count, -w_count, p_count, f_count]}
    end

    @quiz_results_stats = counts.to_json

    counts = @device.quiz_results
      .where(passed: true)
      .where('quiz_results.created_at >= ?', 7.days.ago)
      .joins(:quiz)
      .group('quizzes.subject')
      .count.map do |k, v|
        {label: k, datum: v}
      end

    @quiz_results_stats_bar = counts.to_json
  end

  def edit

  end

  def destroy
    if @device.present? && @device.removable?
      @device.destroy
      flash[:success]="Device deleted successfully"
    else
      flash[:notice]="Device not found"
    end
    redirect_to devices_path
  end

  def update
    numbers = device_params[:emergency_numbers_attributes]

    if numbers.empty?
      if @device.update(device_params)
        fcm = FCM.new(get_fcm_key)
        registration_id = [@device.fcm_token]
        options = {data: {user_id: "#{current_user.id}",package_name: '',block_type: '1', block_status: @device.is_enabled? ? "1" : "0"}, collapse_key: "push_notification"}
        begin
          response = fcm.send(registration_id, options)
        rescue => e
          raise e.message
        end

        respond_to do |format|
          format.html do
            flash[:success] = 'Device updated successfully.'
            redirect_to devices_path
          end
          format.js
        end
      else
        render :edit
      end
    else
      @parent_number = EmergencyNumber.new(numbers.first.second).phone_number
      if Device.transaction do
        @device.emergency_numbers.delete_all

        if @device.update(device_params)
          true
        else
          raise ActiveRecord::Rollback
        end
      end
        t = current_user.user_tutorials.where(tutorial_id: 1).first
        t.seen = true
        t.save!
        current_user.tutorial_screen = "step_6"
        current_user.save!
        respond_to do |format|
          format.html do
            flash[:success] = 'Device updated successfully.'
            redirect_to devices_path
          end
          format.js
        end
      else
        t = current_user.user_tutorials.where(tutorial_id: 1).first
        t.seen = false
        t.save!
        current_user.tutorial_screen = "step_1"
        current_user.save!

        render :edit
      end
    end
  end

  def quiz_shopping
    params[:view_count] ||=20
    params[:page] ||=1

    if params[:sort_by].blank?
      params[:sort_by] = 'Newest'
    end

    if params[:q].present? || params[:grade_ids].present? || params[:subject_ids].present? || params[:test_preps].present?
      @quizzes = Quiz.where(quiz_status: 'approved').search(whitelist_search_params)
    else
      @quizzes = Quiz.where(quiz_status: 'approved')
    end

    @all_subjects  = Quiz
      .where(quiz_status: 'approved')
      .uniq
      .pluck(:subject)

    @subjects  = @quizzes
      .pluck(:subject,:id)
      .uniq { |e| e[0] }


    @test_preps = @quizzes
      .pluck(:subject)
      .uniq

    @grades = @quizzes
      .select('grades.*')
      .joins(:grades).uniq

    if @quizzes.present?
      @quizzes = @quizzes.order("#{order_by}").page(params[:page]).per(params[:view_count])
    end
    @quizzes ||=[]
  end

  def quiz_results
    @quiz_results = @device.quiz_results
  end

  def quiz_queue
    params[:page] ||=1

    if @device.present? && @device.quizzes.present?
      @quiz_selections = @device.quiz_selections.order('quiz_selections.priority').page(params[:page]).per(60).includes(:quiz)
    else
      @quiz_selections = []
    end
  end

  def update_quiz_position
    @quiz_selections = @device.quiz_selections.order('quiz_selections.priority').page(params[:page]).per(60).includes(:quiz)

    ti = params[:thing][:thing_id]
    rop = params[:thing][:row_order_position]

    @quiz_selections = update_quiz_queue_selections_order!(@quiz_selections, ti.to_i, rop.to_i)

    respond_to do |format|
      format.js { render :quiz_queue }
    end
  end

  def update_row_order
    @device = current_user.devices.find(params[:id])
    @quiz_selections = @device.quiz_selections.order('quiz_selections.priority').page(params[:page]).per(60).includes(:quiz)

    ti = params[:thing][:thing_id]
    rop = params[:thing][:row_order_position]
    @quiz_selections = update_quiz_queue_selections_order!(@quiz_selections, ti.to_i, rop.to_i)

    respond_to do |format|
      format.js { render :quiz_queue }
    end
  end

  def update_quiz_queue_selections_order!(quiz_selections, s_id, s_priority)
    s = quiz_selections.size
    s_priority = [[s_priority, s - 1].min, 0].max
    rs = Array.new(s)

    idx = 0
    quiz_selections.each do |qs|
      if idx == s_priority
        idx += 1
      end

      if qs.id == s_id
        qs.priority = s_priority
      else
        qs.priority = idx
        idx += 1
      end

      rs[qs.priority] = qs
    end

    QuizSelection.transaction do
      quiz_selections.each(&:save!)
    end

    rs
  end

  def toggle_app
    @app = InstallApp.find_by_id params[:id]
    if @app.update_attributes(block_status: params[:block_status])
      @device = @app.device
      fcm = FCM.new(get_fcm_key)
      registration_id = [@device.fcm_token]
      options = {data: {user_id: "#{current_user.id}",package_name: @app.package_name,block_type: '0', block_status: @app.block_status? ? "1" : "0"}, collapse_key: "push_notification"}
      begin 
        response = fcm.send(registration_id, options)
      rescue => e
        raise e.message
      end
      render json: true
    else
      render json: false
    end
  end

  private

    def get_fcm_key 
      "AAAAtZBd6QY:APA91bEvohejiI4jFTvN04vKn7c57ZG-H4pI1hVLnpshtQHYGeMFoT5cg9-4gWaFejD15aree-CyWvIMJP-9HV6ilN6Dltgs6SCR-WNLQW3eJGNAKAf1-lqG4WXyCXlM_L2wlmo1dVoy"
    end

    def device_params
      params.require(:device).permit(
        :name,
        :avatar,
        :avatar_cache,
        :is_enabled,
        :send_mail,
        emergency_numbers_attributes: [
          :name,
          :phone_number
        ]
      )
    end

    def load_device
      id = params[:id]
      if id == 'default'
        @device = current_user.devices.first
      else
        @device = current_user.devices.find(id)
      end
    end

    def whitelist_search_params
      params.slice(:q, :subject, :sort_by, :grade_ids, :subject_ids, :test_preps)
    end

    def order_by
      case params[:sort_by]
      when "Newest"
        "created_at DESC" 
      when "Subject"
        "subject ASC"
      when "Topic"
        "topic ASC"
      when "Quiz Name"
        "name ASC" 
      else
        "created_at DESC"
      end
    end
end
