class AddStripeIdToUsers < ActiveRecord::Migration

  def change
    change_table :users do |t|
      t.string :stripe_id
    end
  end

end
