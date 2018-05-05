class AddApprovalDetailsToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :approval_date, :datetime
  	add_column :quizzes, :approved_by, :string
  end
end
