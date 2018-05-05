class AddJoinTableDevicesQuizzes < ActiveRecord::Migration

  def change
    create_join_table :devices, :quizzes do |t|
      t.index :device_id
      t.index :quiz_id
    end
  end

end
