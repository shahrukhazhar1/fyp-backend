class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :quiz_user_id
      t.integer :quiz_admin_id
      t.integer :quiz_id

      t.timestamps
    end
  end
end
