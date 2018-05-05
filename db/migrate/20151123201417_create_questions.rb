class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to        :quiz
      t.string            :text
      t.integer           :priority
      t.timestamps
    end
  end
end
