class UserPushToken < ApplicationRecord
  belongs_to :user

  validates :token, uniqueness: { scope: :device_id }
  validates :user, :device_id, :token, presence: true
end
