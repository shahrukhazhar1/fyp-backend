class AddIsEnabledToDevices < ActiveRecord::Migration

  def change
    change_table :devices do |t|
      t.boolean :is_enabled, :default => false
    end
  end

end
