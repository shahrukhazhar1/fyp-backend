class AddStatusToQuiz < ActiveRecord::Migration

  def change
    change_table :quizzes do |t|
      t.integer :status, :default => 0
    end
  end

end
