module AisImporter
  class Charges
    attr_reader :account

    def initialize(account_id)
      @account = Account.find(account_id)
    end

    def by_account_and_month(year, month)
      response = AisApiService.charges_by_account_and_month(account.external_id, year, month, account.company)

      return unless response.status == 200

      save_charges(response.body)
      account.charges.where(year:, month:)
    end

    def charges_by_account_and_year(year)
      response = AisApiService.charges_by_account_and_year(account.external_id, year, account.company)

      return unless response.status == 200

      save_charges(response.body)
      account.charges.where(year:)
    end

    private

    def save_charges(body)
      body.each do |charges|
        ch = account.charges.find_or_initialize_by(
          year: charges['periodYear'],
          month: charges['periodMonth'],
          service_name: charges['serviceName']
        )
        ch.attributes = {
          tariff: charges['tariff'],
          unit: charges['unit'],
          norm: charges['norm'],
          norm_unit: charges['normUnit'],
          sum_nach: charges['sumNach'],
          sum_recalc: charges['sumRecalc'],
          sum_nach_all: charges['sumNachAll'],
          consume: charges['consume']
        }
        ch.save!
      rescue StandardError => e
        Rails.logger.warn "User importer error #{account.id} #{e}"
        next
      end
    end
  end
end
