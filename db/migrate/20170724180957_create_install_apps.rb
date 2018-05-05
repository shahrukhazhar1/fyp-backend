class CreateInstallApps < ActiveRecord::Migration
  def change
    create_table :install_apps do |t|
      t.string :app_name
      t.string :package_name
      t.integer :device_id

      t.timestamps null: false
    end
  end
end
