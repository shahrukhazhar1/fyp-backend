module ApplicationHelper
	def flash_class(level)
    case level
      when :notice then "info"
      when :success then "success"
      when :error then "danger"
      when :alert then "danger"
    end
	end

  def quiz_status_tag(device_id,quiz_id)

    qs = QuizSelection.includes(:quiz_results).where(quiz_results: {device_id: device_id},device_id:device_id,quiz_id:quiz_id).last

    if qs.present? && qs.quiz_results.present?
      quiz_result = qs.quiz_results.last
      if quiz_result.passed?
        "<span class='status-passed'>Passed</span>".html_safe
      else
        "<span class='status-failed'>Failed</span>".html_safe
      end
    else
      "<span class='status-not-attempted'>Not Attempted</span>".html_safe
    end
  end

  def get_quiz_percentage(quiz_result)
    correct_count = quiz_result.correct.try(:size)
    wrong_count = quiz_result.wrong.try(:size)
    total_questions = quiz_result.try(:quiz).try(:questions).try(:count)
    total_questions = correct_count + wrong_count if total_questions == 0
    ((quiz_result.correct.size.to_f / (total_questions).to_f) * 100).round(2) rescue 0
  end
end
