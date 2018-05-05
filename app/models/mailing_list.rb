# == Schema Information
#
# Table name: mailing_lists
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MailingList < ActiveRecord::Base
  has_many :user_mailing_lists
  has_many :users, through: :user_mailing_lists
  has_many :mailing_list_entries
end
