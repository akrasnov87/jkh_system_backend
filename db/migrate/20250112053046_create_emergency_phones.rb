class CreateEmergencyPhones < ActiveRecord::Migration[7.1]
  def change
    create_table :emergency_phones do |t|
      t.integer :company, null: false
      t.string :number, null: false
      t.timestamps
    end
  end
end
