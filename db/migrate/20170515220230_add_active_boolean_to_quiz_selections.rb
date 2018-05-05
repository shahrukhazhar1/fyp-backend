class AddActiveBooleanToQuizSelections < ActiveRecord::Migration
  def change
    add_column :quiz_selections, :active, :boolean, default: true
  end
end
