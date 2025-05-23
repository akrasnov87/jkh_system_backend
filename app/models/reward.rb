class Reward < ApplicationRecord
  include Attachable

  validates :company, :title, :body, presence: true
  enum company: CompanyDetail::COMPANY
end
