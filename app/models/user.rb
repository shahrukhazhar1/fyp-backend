# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string
#  stripe_id              :string
#  first_name             :string
#  last_name              :string
#  send_email             :boolean          default(TRUE)
#  tutorial_screen        :string           default("0")
#  tutorial_seen          :boolean          default(TRUE)
#  subscription_start_at  :datetime
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base


  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_token_authenticatable

  has_many :devices
  has_many :subscription

  has_many :user_tutorials
  has_many :roles
  has_many :tutorials, through: :user_tutorials

  has_many :user_mailing_lists
  has_many :mailing_lists, through: :user_mailing_lists

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :create_tutorial_steps
  after_create :add_device
  after_create :set_tutorial_seen

  def set_tutorial_seen
    self.tutorial_screen = "step_5"
    self.tutorial_seen = false
    self.save
  end

  def safe_subscription_start_at
    subscription_start_at || Time.now
  end

  def trial_end_at
    safe_subscription_start_at + 7.days
  end

  def stripe_trial_end_at
    if trial_end_at < Time.now
      'now'
    else
      trial_end_at.to_i
    end
  end

  def add_device
    self.devices.create({
      name: 'My Device',
      is_enabled: false,
      default_device: false,
      emergency_numbers: [
        EmergencyNumber.new({
          name: "#{self.first_name} #{self.last_name}",
          phone_number: '555-555-5555'
        })
      ]
    })
  end

  def create_tutorial_steps
    tutorials = Tutorial.all
    tutorials.each do |tutorial|
      self.user_tutorials.create tutorial_id: tutorial.id, user_id: self.id
    end
  end

  def to_s
    email
  end

  def username
    first_name.to_s + " " + last_name.to_s
  end

end
