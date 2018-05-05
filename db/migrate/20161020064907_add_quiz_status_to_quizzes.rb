class AddQuizStatusToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :quiz_status, :string
  end
end
