class CreateQuestionLabels < ActiveRecord::Migration
  def change
    create_table :question_labels do |t|
      t.integer :question_id
      t.integer :label_id

      t.timestamps null: false
    end
  end
end
