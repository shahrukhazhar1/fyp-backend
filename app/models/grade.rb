# == Schema Information
#
# Table name: grades
#
#  id         :integer          not null, primary key
#  name       :string
#  priority   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_grades_on_name  (name) UNIQUE
#

class Grade < ActiveRecord::Base

  # has_many :quizzes

  has_many :quiz_grades, dependent: :destroy
  has_many :quizzes, through: :quiz_grades

end
