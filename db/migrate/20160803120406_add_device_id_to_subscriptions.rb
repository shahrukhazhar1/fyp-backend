class AddDeviceIdToSubscriptions < ActiveRecord::Migration

  def change
    change_table :subscriptions do |t|
      t.belongs_to :device
    end
  end

end
