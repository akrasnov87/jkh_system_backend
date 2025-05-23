class Ticket < ApplicationRecord
  include Attachable

  belongs_to :user
  belongs_to :account
  belongs_to :department, optional: true

  has_many :replies, dependent: :destroy

  enum status: {
    open: 0,
    pending: 1,
    replayed: 2,
    resolved: 3,
    close: 4
  }

  enum origin: {
    mobile: 0,
    letter: 1,
    in_person: 2,
    gos_jkh: 3,
    supervisory_authority: 4
  }

  scope :where_account_address, -> (address) { joins(:account).where('accounts.address LIKE ?', "%#{address}%") }
  scope :where_account_full_name, -> (full_name) { joins(:account).where('accounts.full_name LIKE ?', "%#{full_name}%") }
  scope :where_account_number, -> (number) { joins(:account).where('accounts.number LIKE ?', "%#{number}%") }
  before_create :move_to_support_department

  def row_color
    return 'bg-rose-50' if sla_expired?

    'bg-yellow-50' if open? || pending?
  end

  def self.ransackable_scopes(*)
    %i(where_account_address where_account_number where_account_full_name)
  end

  private

  def move_to_support_department
    self.department_id = Department.find_by(value: 'support').id
  end
end
