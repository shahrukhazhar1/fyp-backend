class AddPostedByToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :posted_by, :string
  end
end
