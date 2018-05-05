class AddPassedToQuizResults < ActiveRecord::Migration

  def change
    change_table :quiz_results do |t|
      t.boolean :passed, :default => false
    end
  end

end
