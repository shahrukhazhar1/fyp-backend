class CreateWeeklyReports < ActiveRecord::Migration
  def change
    create_table :weekly_reports do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :quiz_result_id

      t.timestamps
    end
  end
end
