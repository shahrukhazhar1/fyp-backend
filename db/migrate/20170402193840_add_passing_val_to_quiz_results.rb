class AddPassingValToQuizResults < ActiveRecord::Migration
  def change
    add_column :quiz_results, :passing_val, :integer
  end
end
