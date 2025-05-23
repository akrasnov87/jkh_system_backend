class CountersValue < ApplicationRecord
  belongs_to :counter
  default_scope { order(year: :desc, month: :desc) }
end
