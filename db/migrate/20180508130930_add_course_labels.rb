class AddCourseLabels < ActiveRecord::Migration
  def change
    create_table :course_labels do |t|
      t.integer :course_id
      t.integer :label_id

      t.timestamps null: false
    end
  end
end
