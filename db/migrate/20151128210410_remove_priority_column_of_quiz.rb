class RemovePriorityColumnOfQuiz < ActiveRecord::Migration

  def up
    change_table :quizzes do |t|
      t.remove :priority
    end
  end

  def down
    change_table :quizzes do |t|
      t.integer :priority
    end
  end

end
