# == Schema Information
#
# Table name: tutorials
#
#  id         :integer          not null, primary key
#  page_name  :string
#  created_at :datetime
#  updated_at :datetime
#

class Tutorial < ActiveRecord::Base
  has_many :user_tutorials
  
  has_many :users, through: :user_tutorials
end
