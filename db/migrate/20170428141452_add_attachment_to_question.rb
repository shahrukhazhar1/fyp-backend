class AddAttachmentToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :attachment, :string
  end
end
