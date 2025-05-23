class Push < ApplicationRecord
  belongs_to :user
  validates :title, :whodunit, :body, :user_id, presence: true
end
