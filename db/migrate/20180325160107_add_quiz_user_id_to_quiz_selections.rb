class AddQuizUserIdToQuizSelections < ActiveRecord::Migration
  def change
    add_column :quiz_selections, :quiz_user_id, :integer

  end
end
