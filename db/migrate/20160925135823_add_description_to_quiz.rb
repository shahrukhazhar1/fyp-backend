class AddDescriptionToQuiz < ActiveRecord::Migration
  def change
  	add_column :quizzes, :description, :string
  end
end
