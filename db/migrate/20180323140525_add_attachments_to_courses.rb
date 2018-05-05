class AddAttachmentsToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :attachment, :string
  	add_column :courses, :attachment2, :string
  end
end
