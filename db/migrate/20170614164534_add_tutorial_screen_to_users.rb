class AddTutorialScreenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tutorial_screen, :integer, default: 0
  end
end
