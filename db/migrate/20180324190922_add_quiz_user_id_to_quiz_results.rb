class AddQuizUserIdToQuizResults < ActiveRecord::Migration
  def change
    add_column :quiz_results, :quiz_user_id, :integer
  end
end
