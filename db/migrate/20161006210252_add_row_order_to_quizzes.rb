class AddRowOrderToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :row_order, :integer
  end
end
