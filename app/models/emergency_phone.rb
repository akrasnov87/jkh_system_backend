class EmergencyPhone < ApplicationRecord
  validates :number, presence: true
  validates :company, presence: true, uniqueness: true

  enum company: CompanyDetail::COMPANY
end
