module ApiHelpers
  def bearer_token
    (request.headers['authorization'] || request.headers['Authorization']).split(' ').last
  rescue StandardError
    nil
  end

  def current_token
    @current_token ||= ApiToken.where(token: bearer_token).first
  end

  def current_user
    @current_user ||= current_token.try(:user)
  end

  def authenticate!
    error!('401 Unauthorized', 401) if current_user.nil? || current_user.access_locked?
  end

  def active_error!(namespace, model)
    error!({ errors: model.errors.messages.each_with_object({}) do |e, res|
                       res["#{namespace}[#{e[0]}]"] = e[1]
                       res
                     end }, 400)
  end

  def rails_request
    @rails_request ||= ActionDispatch::Request.new(env)
  end

  def permitted_params
    @permitted_params ||= declared(params, include_missing: false).to_h
  end
end
