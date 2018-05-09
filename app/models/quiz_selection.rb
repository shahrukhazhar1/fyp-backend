# == Schema Information
#
# Table name: quiz_selections
#
#  id         :integer          not null, primary key
#  device_id  :integer
#  quiz_id    :integer
#  priority   :integer
#  created_at :datetime
#  updated_at :datetime
#  owner      :boolean          default(FALSE)
#  active     :boolean          default(TRUE)
#
# Indexes
#
#  index_quiz_selections_on_device_id              (device_id)
#  index_quiz_selections_on_device_id_and_quiz_id  (device_id,quiz_id)
#  index_quiz_selections_on_quiz_id                (quiz_id)
#

class QuizSelection < ActiveRecord::Base

  default_scope { where(active: true) }

  belongs_to :device, :touch => true
  belongs_to :quiz
  has_many :quiz_results
  before_create :set_priority

  def self.device_selection(device_id, quiz_id,removal)
    if removal == "true"
      quiz = find_by(quiz_id: quiz_id, device_id: device_id)
      quiz.active = false
      quiz.save
    else
      quiz = find_or_create_by(quiz_id: quiz_id, device_id: device_id) if device_id && quiz_id
      quiz.update(active:true) if quiz.persisted?
    end
  end
  
  def change_order(move)
    if move > 0
      below = self.class.joins(:quiz).where("device_id = ? AND priority < ?", self.device_id, self.priority)
        .order('priority DESC').first
      if below.present?
        below.increment(:priority).save
        self.decrement(:priority).save
      end
    else
      above = self.class.joins(:quiz).where("device_id = ? AND priority > ?", self.device_id, self.priority)
        .order('priority ASC').first
      if above.present?
        above.decrement(:priority).save
        self.increment(:priority).save
      end
    end
  end

  private

    def set_priority
      self.priority = (self.class.joins(:quiz).where("device_id = ?", self.device_id).maximum(:priority) || 0) + 1
    end

end
