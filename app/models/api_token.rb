class ApiToken < ApplicationRecord
  KINDS = { iphone: 0, android: 1 }.freeze

  belongs_to :user
  validates :user, :token, presence: true

  before_save :generate_token, unless: :token?

  enum kind: KINDS

  def generate_token
    self.token = SecureRandom.hex(32)
    if ApiToken.where(token:).any?
      generate_token
    else
      save
    end
  end
end
