class AddUniqueConstraintToQuizIdGradeIdOnQuizGrade < ActiveRecord::Migration
  def change
    add_index :quiz_grades, [:quiz_id, :grade_id], :unique => true
  end
end
