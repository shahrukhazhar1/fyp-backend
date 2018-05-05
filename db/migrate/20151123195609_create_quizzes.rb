class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string                :name
      t.string                :subject
      t.string                :standard
      t.integer               :priority
      t.timestamps
    end
  end
end
