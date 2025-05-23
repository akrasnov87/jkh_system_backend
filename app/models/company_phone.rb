class CompanyPhone < ApplicationRecord
  validates :name, :number, presence: true
end
