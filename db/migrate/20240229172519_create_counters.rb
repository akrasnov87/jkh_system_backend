class CreateCounters < ActiveRecord::Migration[7.1]
  def change
    create_table :counters do |t|
      t.bigint :account_id, index: true
      t.bigint :external_id, index: true
      t.string :counter_name
      t.string :serial_code
      t.string :service_name
      t.string :service_group
      t.datetime :last_check

      t.timestamps
    end
  end
end
