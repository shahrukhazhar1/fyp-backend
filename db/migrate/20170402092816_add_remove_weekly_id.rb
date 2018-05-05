class AddRemoveWeeklyId < ActiveRecord::Migration
  def change
    remove_column :weekly_reports, :quiz_result_id
    add_column :quiz_results, :weekly_report_id, :integer
  end
end
