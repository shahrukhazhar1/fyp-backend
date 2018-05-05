class CreateUserTutorials < ActiveRecord::Migration
  def change
    create_table :user_tutorials do |t|
      t.integer :user_id
      t.integer :tutorial_id
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
