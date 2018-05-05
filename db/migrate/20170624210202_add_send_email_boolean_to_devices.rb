class AddSendEmailBooleanToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :send_mail, :boolean, default: true
  end
end
