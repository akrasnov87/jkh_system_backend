class CreateCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :charges do |t|
      t.references :account
      t.integer :year, null: false
      t.integer :month, null: false
      t.string :service_name, null: false
      t.string :tariff
      t.text :unit
      t.string :norm
      t.text :norm_unit
      t.string :sum_nach
      t.string :sum_recalc
      t.string :sum_nach_all
      t.string :consume

      t.timestamps
    end
  end
end
