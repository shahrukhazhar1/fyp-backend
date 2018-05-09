# == Schema Information
#
# Table name: coupons
#
#  id                :integer          not null, primary key
#  code              :string
#  free_trial_length :string
#  created_at        :datetime
#  updated_at        :datetime
#

class Coupon < ActiveRecord::Base
  
  has_many :subscriptions

end
