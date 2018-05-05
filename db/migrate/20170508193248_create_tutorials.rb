class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string :page_name

      t.timestamps
    end
  end
end
