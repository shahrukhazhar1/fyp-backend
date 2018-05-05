# == Schema Information
#
# Table name: question_labels
#
#  id          :integer          not null, primary key
#  question_id :integer
#  label_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class QuestionLabel < ActiveRecord::Base
	belongs_to :question
	belongs_to :label
end
