class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :auth_token, unique:true
      t.index :auth_token, unique: true
      t.integer :quiz_user_id
      t.integer :quiz_admin_id

      t.timestamps
    end
  end
end
