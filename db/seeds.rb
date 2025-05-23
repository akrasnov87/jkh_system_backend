# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
1..10000.times do
  Account.create!(
    company: 0,
    date_end: Time.current + 10.years,
    date_begin: Time.current,
    address: Faker::Address.full_address,
    number: Faker::Number.number(digits: 10),
    external_id: Faker::Number.number(digits: 10),
    full_name: Faker::Name.name,
    house: Faker::Address.full_address,
    phone: Faker::PhoneNumber.cell_phone,
    )
end

{ support: 'Поддержка', finance: 'Бухгалтерия', rky: 'РКУ', economist: 'Экономист',
  pto: 'ПТО', lawyer: 'Юрист', developer: 'Программисты', payment_service: 'Платные услуги' }.each do |k, v|
  next if Department.exists?(value: k)
  Department.create(name: v, value: k)
end