# == Schema Information
#
# Table name: course_labels
#
#  id          :integer          not null, primary key
#  course_id :integer
#  label_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CourseLabel < ActiveRecord::Base
	belongs_to :course
	belongs_to :label
end
