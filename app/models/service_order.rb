class ServiceOrder < ApplicationRecord
  include Attachable

  belongs_to :account, optional: true
  belongs_to :user, optional: true
  belongs_to :service_category, optional: true
  belongs_to :service_work, optional: true
  has_many :service_payments, -> { order(created_at: :desc) }, dependent: :nullify
  has_many :service_replies, dependent: :destroy

  enum company: CompanyDetail::COMPANY
  enum status: { unpaid: 0, paid: 1, resolve: 2, close: 3 }
end
