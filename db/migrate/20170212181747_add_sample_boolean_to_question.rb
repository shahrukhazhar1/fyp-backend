class AddSampleBooleanToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :sample, :boolean, default: false
  end
end
