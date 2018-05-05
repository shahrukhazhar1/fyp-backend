class AddAuthTokenToQuizUsers < ActiveRecord::Migration
  def change
    add_column :quiz_users, :authentication_token, :string
    add_index :quiz_users, :authentication_token, unique: true
  end
end
