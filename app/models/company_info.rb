class CompanyInfo < ApplicationRecord
  include Attachable

  validates :address, :company, :email, :phone, :working_schedules, presence: true

  enum company: CompanyDetail::COMPANY
end
