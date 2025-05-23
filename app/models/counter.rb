class Counter < ApplicationRecord
  belongs_to :account
  has_many :counters_values, dependent: :destroy

  delegate :company, to: :account
  validates :external_id, presence: true, uniqueness: { scope: :account_id }
end
