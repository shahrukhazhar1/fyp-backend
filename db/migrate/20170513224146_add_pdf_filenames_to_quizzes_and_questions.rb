class AddPdfFilenamesToQuizzesAndQuestions < ActiveRecord::Migration
  def change
    add_column :quizzes, :supplement_filename, :string
    add_column :quizzes, :guide_filename, :string
    add_column :questions, :guide_filename, :string
  end
end
