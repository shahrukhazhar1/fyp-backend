class AddCanceledAtTimestampToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :canceled_at, :timestamp
  end
end
