class UsefulContact < ApplicationRecord
  validates :company, :name, :number, presence: true

  enum company: CompanyDetail::COMPANY
end
