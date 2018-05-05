class RemoveGradeIdFromQuizzes < ActiveRecord::Migration
  def change
  	remove_column :quizzes, :grade_id
  end
end
