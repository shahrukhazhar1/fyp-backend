class AddDefaultDeviceBoolean < ActiveRecord::Migration
  def change
    add_column :devices, :default_device, :boolean, default: false
  end
end
