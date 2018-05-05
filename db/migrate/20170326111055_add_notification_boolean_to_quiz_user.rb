class AddNotificationBooleanToQuizUser < ActiveRecord::Migration
  def change
  	add_column :quiz_users, :email_alert, :boolean, default: false
  end
end
