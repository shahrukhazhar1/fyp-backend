class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :label
      t.references :user, index: true, foreign_key: true
    end
  end
end
