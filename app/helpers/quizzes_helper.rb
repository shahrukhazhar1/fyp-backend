module QuizzesHelper

  BADGE_COLOR = {
    'awaiting_approval' => :primary,
    'approved' => :success,
    'rejected' => :danger
  }

  def humanized_status(quiz)
    content_tag :span, quiz.status.humanize, :class => "label label-#{ BADGE_COLOR[quiz.status] }"
  end
end
