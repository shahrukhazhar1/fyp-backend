class CreateEmergencyNumbers < ActiveRecord::Migration
  def change
    create_table :emergency_numbers do |t|
      t.belongs_to  :device
      t.string      :name
      t.string      :phone_number
      t.timestamps
    end
  end
end
