class Payment < ApplicationRecord
  STATUSES = {
    created: 0,
    paid: 1,
    reversed: 2,
    refunded: 3,
    revoked: 4,
    declined: 5,
    expired: 6,
    authorized: 7,
    confirmed: 8,
    on_payments: 9
  }.freeze
  belongs_to :account
  delegate :company, to: :account

  enum status: STATUSES

  enum kind: {
    sber: 0,
    sbp: 1,
    gateway: 2
  }
end
