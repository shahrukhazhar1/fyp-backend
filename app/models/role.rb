# == Schema Information
#
# Table name: roles
#
#  id      :integer          not null, primary key
#  label   :string
#  user_id :integer
#
# Indexes
#
#  index_roles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Role < ActiveRecord::Base
  belongs_to :user
end
