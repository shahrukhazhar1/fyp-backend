class CreateQuizResults < ActiveRecord::Migration

  def change
    create_table :quiz_results do |t|
      t.belongs_to :device
      t.belongs_to :quiz_selection
      t.integer    :correct,  :array => true, :default => []
      t.integer    :wrong,    :array => true, :default => []
      t.timestamps
    end
  end

end
