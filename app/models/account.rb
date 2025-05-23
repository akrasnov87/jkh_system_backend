class Account < ApplicationRecord
  SBP_COMPANY_PAYMENT = %w(yk_td td yut)

  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
  has_many :counters, dependent: :destroy
  has_many :counters_values, through: :counters, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :service_orders, dependent: :nullify

  enum company: CompanyDetail::COMPANY

  scope :active, -> { where('date_end > ?', Time.current) }
  scope :where_account_users, -> (value) {
    if value == 'yes'
      joins(:account_users).distinct
    else
      left_joins(:account_users).where(account_users: { id: nil })
    end
  }

  def self.ransackable_scopes(*)
    %i(where_account_users)
  end
end
