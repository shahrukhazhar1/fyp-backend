# == Schema Information
#
# Table name: billings
#
#  id              :integer          not null, primary key
#  subscription_id :integer
#  start_date      :datetime
#  end_date        :datetime
#  last_four       :string(255)
#  card_type       :string(255)
#  price           :float
#  created_at      :datetime
#  updated_at      :datetime
#

class Billing < ActiveRecord::Base

  belongs_to :subscription

end
