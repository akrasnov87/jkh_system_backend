class CreateCompanyPhones < ActiveRecord::Migration[7.1]
  def change
    create_table :company_phones do |t|
      t.string :name
      t.string :number
      t.timestamps
    end
  end
end
