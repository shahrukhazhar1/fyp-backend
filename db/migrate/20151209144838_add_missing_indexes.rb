class AddMissingIndexes < ActiveRecord::Migration

  def change
    add_index :quiz_selections, :device_id
    add_index :quiz_selections, :quiz_id
    add_index :quiz_selections, [:device_id, :quiz_id]
    add_index :quiz_results, :device_id
    add_index :quiz_results, :quiz_selection_id
    add_index :quizzes, :grade_id
    add_index :questions, :quiz_id
    add_index :emergency_numbers, :device_id
    add_index :devices, :user_id
    add_index :answers, :question_id
  end

end
