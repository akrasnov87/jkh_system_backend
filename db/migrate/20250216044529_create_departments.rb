class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.string :value
      t.timestamps
    end

    add_reference :users, :department, index: true
    add_reference :tickets, :department, index: true

    { support: 'Поддержка', finance: 'Бухгалтерия', rky: 'РКУ', economist: 'Экономист',
      pto: 'ПТО', lawyer: 'Юрист', developer: 'Программисты', payment_service: 'Платные услуги' }.each do |k, v|
      next if Department.exists?(value: k)
      Department.create(name: v, value: k)
    end
  end
end
