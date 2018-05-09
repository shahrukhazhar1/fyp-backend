# == Schema Information
#
# Table name: quiz_users
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
#  email_alert            :boolean          default(FALSE)
#
# Indexes
#
#  index_quiz_users_on_authentication_token  (authentication_token) UNIQUE
#  index_quiz_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_quiz_users_on_email                 (email) UNIQUE
#  index_quiz_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class QuizUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :quizzes
  has_many :authentications, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  def ensure_authentication_token
    auth_token = generate_authentication_token
    self.authentications.create auth_token:auth_token
    self.save!
    auth_token
  end
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Authentication.find_by_auth_token(token)
    end
  end
end
