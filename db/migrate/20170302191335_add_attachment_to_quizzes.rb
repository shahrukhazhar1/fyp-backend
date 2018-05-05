class AddAttachmentToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :attachment, :string
  end
end
