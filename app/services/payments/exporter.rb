module Payments
  class Exporter
    include Helpers
    attr_reader :company

    COMPANY_MASK = {
      yut: '83567',
      yut_plus: '28106',
      nash_dom: '12500',
      progress: '08704',
      td: '11121',
      yk_td: '04873',
      yk_centr: '03484',
      yk_jkh: '00000'
    }.freeze

    COMPANY_EMAIL = {
      yut: ENV['YUT_EMAIL'],
      td: ENV['TD_EMAIL'],
      yk_td: ENV['YK_TD_EMAIL'],
      yk_centr: ENV['YK_CENTR_EMAIL'],
      yk_jkh: ENV['YK_JKH_EMAIL']
    }.freeze

    def initialize(company)
      @company = company
    end

    def call
      filename = "payments_#{company}_#{Time.zone.yesterday}.txt"
      file = Tempfile.new(filename)
      payments = Payment.paid.where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day)
                        .joins(:account).where(accounts: { company: })
      CSV.open(file, 'w+', col_sep: ';') do |csv|
        payments.find_each do |payment|
          csv << payment_row(payment)
        end
      end
      PaymentsMailer.exporter(COMPANY_EMAIL[company.to_sym], file, filename).deliver_now if payments.any?
      file.close
      file.unlink
    end

    def payment_row(payment)
      row = []
      row << export_data(payment.created_at)
      row << export_time(payment.created_at)
      row << nil
      row << nil
      row << nil
      row << "#{COMPANY_MASK[company]}#{payment.account.number}"
      row << nil
      row << nil
      row << nil
      row << payment.order_sum.to_s.tr('.', ',')
      row << payment.order_sum.to_s.tr('.', ',')
      row << '0,00'
      row << nil
    end
  end
end
