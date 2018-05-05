class AddStudyGuideToQuestions < ActiveRecord::Migration
  def change
  	add_column :questions, :study_guide, :text
  	add_column :questions, :study_guide_attachment, :string
  end
end
