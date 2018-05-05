class AddTopicToQuiz < ActiveRecord::Migration
  def change
  	add_column :quizzes, :topic, :string
  end
end
