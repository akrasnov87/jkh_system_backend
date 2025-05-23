class ServicePayment < ApplicationRecord
  acts_as_paranoid

  belongs_to :service_order
  has_one :account, through: :service_order
  has_one :user, through: :service_order

  enum status: Payment::STATUSES
end
