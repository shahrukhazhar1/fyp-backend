class AddSubscriptionStartAtTimestampToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_start_at, :timestamp
  end
end
