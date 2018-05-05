class AddQuizGuide < ActiveRecord::Migration
  def change
  	add_column :quizzes, :quiz_guide, :text
  	add_column :quizzes, :quiz_guide_attachment, :string
  end
end
