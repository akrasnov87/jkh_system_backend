class ServiceCategory < ApplicationRecord
  has_many :service_works, dependent: :destroy
  has_many :service_orders, dependent: :nullify

  enum company: CompanyDetail::COMPANY

  enum image: {
    notification: 0,
    notification_red_dot: 1,
    person: 2,
    home: 3,
    card: 4,
    counter: 5,
    camera: 6,
    doc: 7,
    request: 8,
    settings: 9,
    services: 10,
    info: 11,
    cleaning: 12,
    receipts: 13,
    communication: 14,
    holidays: 15,
    repair: 16,
    electric: 17,
    home_2: 18,
    water: 19,
    heating: 20,
    money: 21,
    phone: 22,
    internet: 23,
    arrow: 24,
    reward: 25,
    security: 26,
    warning: 27,
    add: 28
  }
end
