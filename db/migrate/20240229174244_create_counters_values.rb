class CreateCountersValues < ActiveRecord::Migration[7.1]
  def change
    create_table :counters_values do |t|
      t.bigint :counter_id, index: true, null: false
      t.decimal :val
      t.integer :year
      t.integer :month
      t.boolean :is_consume, null: false, default: true

      t.timestamps
    end
  end
end
