class AccountPolicy < ApplicationPolicy
  def options?
    user.admin? || user.super_admin? || user.staff?
  end
end
