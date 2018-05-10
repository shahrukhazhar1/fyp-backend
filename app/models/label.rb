# == Schema Information
#
# Table name: labels
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Label < ActiveRecord::Base
	has_many :question_labels, dependent: :destroy
	has_many :questions, through: :question_labels

	has_many :course_labels, dependent: :destroy
	has_many :courses, through: :course_labels
end
