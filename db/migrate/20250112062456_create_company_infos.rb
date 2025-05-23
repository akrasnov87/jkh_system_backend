class CreateCompanyInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :company_infos do |t|
      t.integer :company, null: false, default: 0
      t.string :address, null: false, default: ''
      t.string :phone, null: false, default: ''
      t.string :email, null: false, default: ''
      t.text :working_schedules, null: false, default: ''
      t.timestamps
    end
  end
end
