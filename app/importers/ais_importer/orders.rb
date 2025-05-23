module AisImporter
  class Orders
    attr_reader :account, :order, :month

    def initialize(account)
      @account = account
      @order = Order.find_or_create_by(account_id: account.id,
                                       month: Date.current.month,
                                       year: Date.current.year)
      @month = Date.current.month
    end

    def call
      response = (0..1).each do |number|
        send_month = month - number
        request = AisApiService.current_total_sum_by_account(account, send_month)

        break request if request.status == 200

        if number == 1
          order.update(sum_to_pay: 0)
          break request
        end
      end
      if response.status == 200
        save_current_sum_to_pay(response.body)
      else
        Rails.logger.warn "Order update error #{response.body} #{response.status}"
        order
      end
    end

    def save_current_sum_to_pay(body)
      return order unless body.any?

      attributes = if body['periodMonth'] == Date.current.month
                     { sum_to_pay: fetch_sum_debt(body), actual_payment: true }
                   else
                     { sum_to_pay: fetch_sum_total_sum_pay(body) }
                   end

      order.update(attributes)
      order
    end

    def fetch_sum_total_sum_pay(body)
      ((body['totalSumPay'] || 0) + (body['penja'] || 0)).round(2)
    end

    def fetch_sum_debt(body)
      ((body['debt'] || 0) + (body['penja'] || 0)).round(2)
    end
  end
end
