class AddingQuizAndQuestionPdfThumbnail < ActiveRecord::Migration
  def change
    add_column :quizzes, :supplement_pdf_preview, :string
    add_column :quizzes, :quiz_guide_pdf_preview, :string
    add_column :questions, :question_guide_pdf_preview, :string
  end
end
