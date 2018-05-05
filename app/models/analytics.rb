class Analytics

  attr_accessor :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def avg_quizzes_per_device
    quizzes_per_device = @current_user.devices.joins(:quizzes).group('devices.id').count
    (quizzes_per_device.values.sum.to_f / quizzes_per_device.keys.count.to_f).round 2
  end

  def questions_answered_per_device
    QuizResult.joins(:device).where('devices.user_id = ?', @current_user.id).group('devices.id').sum('array_length(correct || wrong, 1)')
  end

  def total_correct_questions_per_device
    QuizResult.joins(:device).where('devices.user_id = ?', @current_user.id).group('devices.id').sum('array_length(correct, 1)')
  end

  def total_wrong_questions_per_device
    QuizResult.joins(:device).where('devices.user_id = ?', @current_user.id).group('devices.id').sum('array_length(wrong, 1)')
  end

  def total_quizzes
    QuizSelection.joins(:device).where('devices.user_id = ?', @current_user.id).count
  end

  def avg_correct_answer_percentage
    ((total_correct_questions_per_device.blank? ? 0 : total_correct_questions_per_device.values.sum.to_f / questions_answered_per_device.values.sum.to_f) * 100).round 2
  end

end
