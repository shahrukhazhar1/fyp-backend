class AddCommentToQuestions < ActiveRecord::Migration
  def change
  	add_column :questions, :comment, :text, :limit => nil
  end
end
