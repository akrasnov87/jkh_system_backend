class CreateCompanyDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :company_details do |t|
      t.integer :company, null: false, default: 0
      t.string :name, null: false
      t.string :address, null: false
      t.string :inn, null: false
      t.string :kpp, null: false
      t.string :bill_type, null: false
      t.string :bill_number, null: false
      t.string :bank_name, null: false
      t.string :bik, null: false
      t.string :bill_cor, null: false

      t.timestamps
    end
  end
end
