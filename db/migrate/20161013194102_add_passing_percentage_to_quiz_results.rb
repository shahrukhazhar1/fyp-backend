class AddPassingPercentageToQuizResults < ActiveRecord::Migration
  def change
  	add_column :quiz_results, :passing_percentage, :integer
  end
end
