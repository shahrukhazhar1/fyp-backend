class AddGradeIdToQuiz < ActiveRecord::Migration

  def up
    change_table :quizzes do |t|
      t.belongs_to :grade
      t.remove :standard
    end
  end

  def down
    change_table :quizzes do |t|
      t.remove :grade_id
      t.string :standard
    end
  end

end
