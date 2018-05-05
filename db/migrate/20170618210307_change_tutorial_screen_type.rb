class ChangeTutorialScreenType < ActiveRecord::Migration
  def change
    change_column :users, :tutorial_screen, :string
  end
end
