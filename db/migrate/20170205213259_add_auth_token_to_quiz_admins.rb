class AddAuthTokenToQuizAdmins < ActiveRecord::Migration
  def change
  	add_column :quiz_admins, :authentication_token, :string
    add_index :quiz_admins, :authentication_token, unique: true
  end
end
