class UserBuilder
  attr_accessor :phone, :user_by_phone, :user_by_email

  def initialize(phone)
    self.phone = phone
    self.user_by_phone = User.find_by(phone:)
  end

  def perform
    return user_by_phone if user_by_phone.present?

    create_and_return_new_user
  end

  private

  def create_and_return_new_user
    generated_password = Devise.friendly_token.first(8)
    user = User.new(phone:, password: generated_password)
    user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    user.save!
    user
  end
end
