class CreateQuizGrades < ActiveRecord::Migration
  def change
    create_table :quiz_grades do |t|
      t.integer :quiz_id
      t.integer :grade_id

      t.timestamps
    end
  end
end
