class AddHintToQuestion < ActiveRecord::Migration

  def change
    change_table :questions do |t|
      t.string :hint
    end
  end

end
