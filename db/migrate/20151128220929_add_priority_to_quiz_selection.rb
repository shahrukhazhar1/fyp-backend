class AddPriorityToQuizSelection < ActiveRecord::Migration

  def up
    change_table :devices_quizzes do |t|
      t.integer :priority
    end
  end

  def down
    change_table :devices_quizzes do |t|
      t.remove :priority
    end
  end

end
