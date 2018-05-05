class AddedOwnerToQuizSelections < ActiveRecord::Migration

  def change
    change_table :quiz_selections do |t|
      t.boolean  :owner, :default => :false
    end
  end

end
