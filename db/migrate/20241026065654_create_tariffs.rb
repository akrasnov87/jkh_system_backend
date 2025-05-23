class CreateTariffs < ActiveRecord::Migration[7.1]
  def change
    create_table :tariffs do |t|
      t.integer :company, null: false, default: 0
      t.string :name, null: false
      t.string :value, null: false
      t.timestamps
    end
  end
end
