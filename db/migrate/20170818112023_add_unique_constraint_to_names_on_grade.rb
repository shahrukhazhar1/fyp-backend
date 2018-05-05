class AddUniqueConstraintToNamesOnGrade < ActiveRecord::Migration
  def change
    add_index :grades, [:name], :unique => true
  end
end
