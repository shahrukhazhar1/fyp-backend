class CreateBillings < ActiveRecord::Migration

  def change
    create_table :billings do |t|
      t.belongs_to :subscription
      t.datetime :start_date
      t.datetime :end_date
      t.string   :last_four
      t.string   :card_type
      t.float    :price
      t.timestamps
    end
  end

end
