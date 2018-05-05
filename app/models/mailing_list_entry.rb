# == Schema Information
#
# Table name: mailing_list_entries
#
#  id                :integer          not null, primary key
#  mailing_list_id   :integer
#  name              :string
#  email             :string
#  unsubscribe_token :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_mailing_list_entries_on_mailing_list_id            (mailing_list_id)
#  index_mailing_list_entries_on_mailing_list_id_and_email  (mailing_list_id,email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (mailing_list_id => mailing_lists.id)
#

class MailingListEntry < ActiveRecord::Base
  belongs_to :mailing_list

  validates :email, {
    uniqueness: {
      scope: :mailing_list,
      message: "Email is not unique per mailing list",
    },
    presence: {
      message: "Email is required"
    }
  }

  validates_format_of :email, {
    with: Devise.email_regexp,
    message: "Email does not match format",
  }
end
