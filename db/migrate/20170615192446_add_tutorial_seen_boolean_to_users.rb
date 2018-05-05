class AddTutorialSeenBooleanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tutorial_seen, :boolean, default: true
  end
end
