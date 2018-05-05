class AddSupplementTextToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :supplement_text, :text
  end
end
