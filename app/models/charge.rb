class Charge < ApplicationRecord
  belongs_to :account
  validates :year, :month, :service_name, presence: true
end
