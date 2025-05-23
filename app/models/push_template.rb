class PushTemplate < ApplicationRecord
  validates :title, :body, :company, presence: true

  enum company: CompanyDetail::COMPANY

  scope :by_company, -> (user) { where(company: user.companies) }

  def url_action=(value)
    self.data = { url_action: value }
  end

  def url_action
    data&.dig('url_action')
  end
end
