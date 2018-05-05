class AddRemoveMultipleColumnsFromWeeklyReports < ActiveRecord::Migration
  def change
    remove_column :quiz_results, :weekly_report_id
    add_column :weekly_reports, :device_id, :integer
  end
end
