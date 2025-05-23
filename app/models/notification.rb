class Notification < ApplicationRecord
  include Attachable

  validates :image, :title, :body, :whodunit, :kind, presence: true
  validates :house, presence: true, if: :personal_house?
  has_many :icons, -> { icon }, class_name: 'Attachment', as: :attachable
  has_many :news_images, -> { default }, class_name: 'Attachment', as: :attachable

  accepts_nested_attributes_for :icons, allow_destroy: true

  enum company: CompanyDetail::COMPANY

  enum url_action: {
    menu: 0,
    notificationsPage: 1,
    settingsPage: 2,
    moreInfoFirstPage: 3,
    moreInfoSecondPage: 4,
    moreInfoThirdPage: 5,
    moreInfoRewardPage: 6,
    lsPage: 7,
    requestsPage: 8,
    paidServicesScreen: 9,
    paidServicesPage: 10,
    metersVerificationPage: 11,
    metersPage: 12
  }

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

  enum kind: {
    general: 0,
    personal_company: 1,
    personal_house: 2
  }

  scope :active, -> { where(active: true) }
end
