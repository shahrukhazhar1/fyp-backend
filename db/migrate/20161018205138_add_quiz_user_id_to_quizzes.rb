class AddQuizUserIdToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :quiz_user_id, :integer
  	add_index :quizzes, :quiz_user_id
  end
end
