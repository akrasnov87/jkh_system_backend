class ServiceWork < ApplicationRecord
  belongs_to :service_category
  has_many :service_orders, dependent: :nullify

  enum company: CompanyDetail::COMPANY
end
