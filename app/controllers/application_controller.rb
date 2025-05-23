class ApplicationController < ActionController::Base
  authorize :user, through: :current_user

  def after_sign_in_path_for(_resource)
    staff_tickets_path
  end
end
