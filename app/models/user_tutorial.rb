# == Schema Information
#
# Table name: user_tutorials
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  tutorial_id :integer
#  seen        :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class UserTutorial < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutorial
end
