# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  attachment  :string
#  attachment2 :string
#  support     :boolean          default(FALSE)
#

class Course < ActiveRecord::Base
	has_many :quizzes
  mount_uploader :attachment, ::MaterialUploader
  mount_uploader :attachment2, ::MaterialUploader

  def as_json(options={})
    self.reload
    {
      :id  =>  self.id,
      :name   =>  self.name,
      :attachment_url  =>  self.attachment.try(:url),
      :attachment2_url  =>  self.attachment2.try(:url),
      :support => self.support,
      :created_at   =>  self.created_at,
      :updated_at =>  self.updated_at
    }
  end

end
