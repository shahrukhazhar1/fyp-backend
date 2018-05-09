# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  quiz_user_id  :integer
#  quiz_admin_id :integer
#  quiz_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  text          :text
#  posted_by     :string
#  question_id   :integer
#
# Indexes
#
#  index_comments_on_question_id  (question_id)
#

class Comment < ActiveRecord::Base
	belongs_to :quiz
	belongs_to :question
	belongs_to :quiz_user
	belongs_to :quiz_admin

	def posted_by_email
		if posted_by == 'admin'
			self.quiz_admin.try(:email)
		else
			self.quiz_user.try(:email)
		end
	end

	def as_json(options={})
    self.reload
    {
      quiz_user_name:  self.quiz_user.try(:email),
      text: self.text,
      id:  self.id,
      created_at:  self.created_at,
      quiz_admin_name: self.quiz_admin.try(:email),
      posted_by: self.posted_by,
      posted_by_email: self.posted_by_email,
      
    }
  end

end
