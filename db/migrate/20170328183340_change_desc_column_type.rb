class ChangeDescColumnType < ActiveRecord::Migration
  def change
  	change_column :quizzes, :description, :text
  end
end
