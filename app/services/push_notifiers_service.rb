class PushNotifiersService
  attr_reader :users, :push_template, :whodunit

  def initialize(user_ids, push_template, whodunit)
    @users = User.where(id: user_ids, send_push_notifications: true).includes(:push_tokens)
    @push_template = push_template
    @whodunit = whodunit
  end

  def call
    users.find_each do |user|
      user.push_tokens.find_each.with_index do |push_token, index|
        if index.zero?
          user.pushes.create(title: push_template.title, body: push_template.body, whodunit:,
                             data: push_template.try(:data) || {})
        end
        client.send_push(push_token.token, push_template)
      end
    end
  end

  private

  def client
    @client ||= FcmClient.new
  end
end
