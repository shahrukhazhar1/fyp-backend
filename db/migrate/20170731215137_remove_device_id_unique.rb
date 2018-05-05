class RemoveDeviceIdUnique < ActiveRecord::Migration
  def change
  	add_index :devices, :device_id
  	remove_index :devices, :device_id
  end
end
