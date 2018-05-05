class CreateQuizSelections < ActiveRecord::Migration

  def change
    drop_table :devices_quizzes
    create_table :quiz_selections do |t|
      t.belongs_to :device
      t.belongs_to :quiz
      t.integer    :priority
      t.timestamps
    end

  end

end
