class AccountsController < ApplicationController
  before_action :authorize!
  def options
    resources = if params[:number].present?
                  Account.where(company: current_user.companies).where('number LIKE ?', "%#{params[:number]}%")
                else
                  []
                end

    render json: resources.map { |a| { text: "#{a.number} #{a.address} ", value: a.id } }.as_json
  end
end
