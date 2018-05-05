# == Schema Information
#
# Table name: quiz_grades
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  grade_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_quiz_grades_on_quiz_id_and_grade_id  (quiz_id,grade_id) UNIQUE
#

class QuizGrade < ActiveRecord::Base
	belongs_to :quiz
	belongs_to :grade
end
