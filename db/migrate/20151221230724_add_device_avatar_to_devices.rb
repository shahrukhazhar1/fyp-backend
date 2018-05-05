class AddDeviceAvatarToDevices < ActiveRecord::Migration

  def change
    change_table :devices do |t|
      t.string      :avatar
    end
  end

end
