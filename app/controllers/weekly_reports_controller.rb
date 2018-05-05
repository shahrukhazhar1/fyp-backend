class WeeklyReportsController < ApplicationController

  before_action :authenticate_user!

  def show
    @weekly_report = WeeklyReport.find_by_id params[:id]

    @device = @weekly_report.device

    # Note: start_date and end_date are datetimes
    qr = @device
      .quiz_results
      .where('quiz_results.created_at <= ?', @weekly_report.end_date)
      .where('quiz_results.created_at >= ?', @weekly_report.start_date)

    @device_name = @device.name

    @quiz_names = qr
      .collect(&:quiz)
      .collect(&:name)
      .uniq
      .take(3)

    @complete_quiz_count = 0

    @total_question_count = 0

    @correct_question_count = 0

    @milestone_count = 0

    qr.each do |quiz_result|
      if quiz_result.quiz.present?
        @complete_quiz_count +=1
        @total_question_count +=quiz_result.quiz.questions.count
      end

      @correct_question_count +=quiz_result.correct.try(:count) ? quiz_result.correct.try(:count) : 0
      @milestone_count = 0
    end

    if @total_question_count.to_i > 0

      @correct_percentage = (@correct_question_count.to_f/@total_question_count.to_f)*100
      @correct_percentage = @correct_percentage.round(2) rescue 0
    else
      @correct_percentage = 0
    end

    # Note: start_date and end_date are datetimes
    counts = @device
      .quiz_results
      .group('created_at::date')
      .order('created_at::date')
      .recent_date(@weekly_report.start_date, @weekly_report.end_date)
      .pluck('created_at::date',
             'SUM(coalesce(array_length(correct, 1),0)) correct_count',
             'SUM(coalesce(array_length(wrong, 1),0)) wrong_count',
             'COUNT(CASE WHEN passed THEN 1 END) passed_count',
             'COUNT(CASE WHEN NOT passed THEN 1 END) failed_count')

    counts = counts.map do |(date, c_count, w_count, p_count, f_count)|
      {label: date.to_date.to_s(:short),
       datum: [c_count, -w_count, p_count, f_count]}
    end

    @quiz_results_stats = counts.to_json

    # Note: start_date and end_date are datetimes
    counts = @device.quiz_results
      .where(passed: true)
      .recent_date(@weekly_report.start_date, @weekly_report.end_date)
      .joins(:quiz)
      .group('quizzes.subject')
      .count.map do |k, v|
        {label: k, datum: v}
      end

    @quiz_results_stats_bar = counts.to_json
  end
end
