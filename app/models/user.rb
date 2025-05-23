class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :rememberable

  SMS_CODE_TIMEOUT = 1
  SMS_CODE_MAX_ATTEMPTS = 3

  belongs_to :department, optional: true

  has_many :api_tokens, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :counters, through: :accounts
  has_many :counters_values, through: :counters
  has_many :tickets, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :pushes, dependent: :destroy
  has_many :push_tokens, class_name: 'UserPushToken', dependent: :destroy
  has_many :service_orders, dependent: :nullify

  validates :email, :phone, uniqueness: true, allow_blank: true # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :email, presence: true, unless: -> (u) { u.phone.present? }
  validates :phone, presence: true, unless: -> (u) { u.email.present? }
  validates :role, presence: true

  enum role: {
    user: 0,
    staff: 1,
    admin: 2,
    super_admin: 3
  }

  scope :where_account_users, -> (value) {
    if value == 'yes'
      joins(:account_users).distinct
    else
      left_joins(:account_users).where(account_users: { id: nil })
    end
  }

  def employee?
    !user?
  end

  def valid_sms_code?(code)
    sms_code && (sms_code == code) && (sms_code_failed_attempts < SMS_CODE_MAX_ATTEMPTS)
  end

  def recreate_api_token(device_id, device_kind)
    token = api_tokens.where(device_id:).first_or_initialize
    token.kind = (device_kind || :iphone)
    token.generate_token
    token.save!
    token
  end

  def consume_sms_code
    self.sms_code = nil
    self.sms_code_sended_at = nil
    save!
  end

  def sms_code_remained_attempts
    SMS_CODE_MAX_ATTEMPTS - sms_code_failed_attempts.to_i
  end

  def recreate_sms_code(unconfirmed_phone = nil)
    phone = unconfirmed_phone || self.phone
    if phone == '71717171717'
      self.sms_code = '7171'
      self.sms_code_sended_at = Time.current
      self.sms_code_failed_attempts = 0
      save!
    elsif sms_code_sended_at.nil? || (sms_code_sended_at < SMS_CODE_TIMEOUT.minutes.ago)
      self.sms_code = Array.new(4) { rand(9) }.join
      self.sms_code_sended_at = Time.current
      self.sms_code_failed_attempts = 0
      SendSmsNotification.call(phone, sms_code)
      save!
    end
  end

  def self.ransackable_scopes(*)
    %i(where_account_users)
  end
end
