class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.belongs_to :user
      t.string     :name
      t.string     :device_id, :unique => true
      t.timestamps
    end
  end
end
