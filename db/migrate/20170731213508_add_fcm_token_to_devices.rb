class AddFcmTokenToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :fcm_token, :string
  end
end
