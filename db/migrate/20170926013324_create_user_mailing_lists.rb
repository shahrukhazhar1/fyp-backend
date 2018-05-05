class CreateUserMailingLists < ActiveRecord::Migration
  def change
    create_table :user_mailing_lists do |t|
      t.references :user, index: true, foreign_key: true
      t.references :mailing_list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
