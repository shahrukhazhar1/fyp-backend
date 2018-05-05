# == Schema Information
#
# Table name: emergency_numbers
#
#  id           :integer          not null, primary key
#  device_id    :integer
#  name         :string(255)
#  phone_number :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_emergency_numbers_on_device_id  (device_id)
#

class EmergencyNumber < ActiveRecord::Base

  belongs_to :device, :touch => true

  validates :name, presence: true
  validates :phone_number, presence: true, format: /(\d\W*){3,}/
  validate :phone_number_not_911

  def to_s
    name
  end

  def phone_number_not_911
    if phone_number.gsub(/\D/, '') == '911'
      errors.add(:phone_number, 'The emergency cannot be 911')
    end
  end
end
