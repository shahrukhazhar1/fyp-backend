# == Schema Information
#
# Table name: authentications
#
#  id            :integer          not null, primary key
#  auth_token    :string(255)
#  quiz_user_id  :integer
#  quiz_admin_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_authentications_on_auth_token  (auth_token) UNIQUE
#

class Authentication < ActiveRecord::Base
  belongs_to :quiz_user
  belongs_to :quiz_admin
  
  validates :auth_token, presence: true, uniqueness: true, allow_nil: false

end
