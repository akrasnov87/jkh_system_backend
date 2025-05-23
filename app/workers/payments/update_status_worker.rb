module Payments
  class UpdateStatusWorker
    include Sidekiq::Job
    sidekiq_options queue: 'payments', retry: false

    def perform(payment_id)
      payment = Payment.find(payment_id)
      if payment.sbp?
        Payments::Status.new(payment).call
      elsif payment.gateway?
        GatewayPayments::Status.new(payment).call
      end
    end
  end
end
