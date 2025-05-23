class AddedAccountToUser
  attr_reader :account, :user, :errors

  def initialize(user, account)
    @user = user
    @account = account
    @errors = {}
  end

  def call
    if account.phone.to_s.include?(Phone.new(user.phone.to_s).to_account)
      return self unless account
      return self if user.accounts.reload.include?(account)

      user.accounts << account
    else
      @errors = { errors: { 'account[number]' => ['Телефон не привязан'] } }
    end
    self
  end
end
