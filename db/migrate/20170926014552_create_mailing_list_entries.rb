class CreateMailingListEntries < ActiveRecord::Migration
  def change
    create_table :mailing_list_entries do |t|
      t.references :mailing_list, index: true, foreign_key: true
      t.string :name
      t.string :email
      t.string :unsubscribe_token

      t.timestamps null: false
    end
  end
end
