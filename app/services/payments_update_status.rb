class PaymentsUpdateStatus
  def self.call
    sbp_payments = Payment.sbp.where('created_at < ? AND status = ?', Time.current - 20.minutes, Payment.statuses[:created])
    sbp_payments.find_each do |payment|
      updated_payment = Payments::Status.new(payment).call
      Payments::Revoke.new(payment).call if updated_payment&.created?
      payment.revoked! if payment.order_sum == '0.0'
    end

    gateway_payments = Payment.gateway.where('created_at < ? AND status = ?', Time.current - 20.minutes, Payment.statuses[:created])
    gateway_payments.find_each do |payment|
      GatewayPayments::Status.new(payment).call
      payment.revoked! if payment.order_sum == '0.0'
    end

    service_payments = ServicePayment.created.where('created_at < ?', Time.current - 20.minutes)
    service_payments.find_each do |payment|
      ServicePayments::Status.new(payment).call
    end
  end
end
