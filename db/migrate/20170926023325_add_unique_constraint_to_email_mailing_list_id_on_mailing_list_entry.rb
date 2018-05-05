class AddUniqueConstraintToEmailMailingListIdOnMailingListEntry < ActiveRecord::Migration
  def change
    add_index :mailing_list_entries, [:mailing_list_id, :email], :unique => true
  end
end
