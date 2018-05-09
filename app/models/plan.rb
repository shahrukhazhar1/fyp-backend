# == Schema Information
#
# Table name: plans
#
#  id            :integer          not null, primary key
#  name          :string
#  stripe_id     :string
#  price         :float
#  interval      :string
#  features      :text
#  highlight     :boolean
#  display_order :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Plan < ActiveRecord::Base
  include Koudoku::Plan

  has_many :subscriptions

end
