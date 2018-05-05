# == Schema Information
#
# Table name: coupons
#
#  id                :integer          not null, primary key
#  code              :string(255)
#  free_trial_length :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Coupon < ActiveRecord::Base
  
  has_many :subscriptions

end
