class AddSupportBoolToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :support, :boolean, default: false
  	
  end
end
