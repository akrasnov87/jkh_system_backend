class Tariff < ApplicationRecord
  validates :name, :explanation, presence: true

  enum company: CompanyDetail::COMPANY
end
