class AddAttachmentToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :attachment, :string
  end
end
