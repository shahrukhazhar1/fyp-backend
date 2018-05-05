class ChangeQuizDescType < ActiveRecord::Migration
  def change
  	change_column :quizzes, :description , :text, :limit => nil
  end
end
