class AddBlockStatusToInstallApps < ActiveRecord::Migration
  def change
    add_column :install_apps, :block_status, :boolean, default: :true
  end
end
