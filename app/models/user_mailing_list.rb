# == Schema Information
#
# Table name: user_mailing_lists
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  mailing_list_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_mailing_lists_on_mailing_list_id  (mailing_list_id)
#  index_user_mailing_lists_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (mailing_list_id => mailing_lists.id)
#  fk_rails_...  (user_id => users.id)
#

class UserMailingList < ActiveRecord::Base
  belongs_to :user
  belongs_to :mailing_list
end
