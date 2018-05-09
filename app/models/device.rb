# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  name           :string
#  device_id      :string
#  created_at     :datetime
#  updated_at     :datetime
#  avatar         :string
#  is_enabled     :boolean          default(FALSE)
#  default_device :boolean          default(FALSE)
#  send_mail      :boolean          default(TRUE)
#  fcm_token      :string
#
# Indexes
#
#  index_devices_on_user_id  (user_id)
#

class Device < ActiveRecord::Base

  belongs_to :user

  has_many :quiz_selections
  has_many :quizzes, :through => :quiz_selections
  has_many :approved_quizzes, -> { where(:quizzes => {:status => 1}) }, :through => :quiz_selections, :source => :quiz

  has_many :weekly_reports
  has_many :quiz_results
  has_many :emergency_numbers

  has_many :install_apps, dependent: :destroy

  has_one :subscription

  validates :name, :presence => true

  validates :emergency_numbers, presence: true

  scope :available, -> { where(device_id: nil) }
  scope :active, -> { where.not(device_id: nil).where.not(device_id: '') }

  accepts_nested_attributes_for :emergency_numbers

  mount_uploader :avatar, ::DeviceAvatarUploader

  def to_s
    name
  end

  def removable?
    non_removable_statuses = ["active", "trialing"].to_set

    if Cogli.is_device_removable?
      true
    else
      if subscription.nil?
        true
      else
        !non_removable_statuses.include?(subscription.stripe_subscription.status)
      end
    end
  end

  def subscription_start_date
    subscription.try(:billings).try(:last).try(:start_date)
  end

  def subscription_end_date
    subscription.try(:billings).try(:last).try(:end_date)
  end
end
