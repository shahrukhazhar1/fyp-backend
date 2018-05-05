class AddTestPrepToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :test_prep, :string
  end
end
