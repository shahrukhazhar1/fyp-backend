# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  text        :text
#  correct     :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  latex       :boolean          default(FALSE)
#  attachment  :string
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#

class Answer < ActiveRecord::Base
  belongs_to :question

  validates :text, :presence => true, unless: ->(user) { user.attachment.present? }
  validates :attachment, presence: true, unless: ->(user){ user.text.present? }

  mount_uploader :attachment, ::MaterialUploader
end
