class AddStudyGuideInQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :study_guide_text, :text
    add_column :quizzes, :study_guide_comment, :text
  end
end
