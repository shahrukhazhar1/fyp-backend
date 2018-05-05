class AnalyticsController < ApplicationController

  before_action :authenticate_user!

  def index
    @analytics = Analytics.new(current_user)

    # First three
    @total_devices = current_user.devices.count
    @active_devices = current_user.devices.active.count
    @avg_quizzes_per_device = @analytics.avg_quizzes_per_device

    # Quiz taken distribution
    @questions_answered_per_device = @analytics.questions_answered_per_device
    @devices_of_question_answered = Device.where :id => @questions_answered_per_device.keys

    # Total Quizzes
    @total_quizzes = @analytics.total_quizzes

    # Correct and Wrong questions
    @total_correct_questions_per_device = @analytics.total_correct_questions_per_device
    @devices_of_correct_questions = Device.where :id => @total_correct_questions_per_device.keys

    @total_wrong_questions_per_device = @analytics.total_wrong_questions_per_device
    @devices_of_wrong_questions = Device.where :id => @total_wrong_questions_per_device.keys

    @avg_correct_answer_percentage = @analytics.avg_correct_answer_percentage
  end

end
