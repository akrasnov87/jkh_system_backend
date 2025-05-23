module AisImporter
  class Counters
    attr_reader :company

    def initialize(company)
      @company = company
    end

    def by_account(account)
      response = AisApiService.counters_by_account(account.external_id, company)

      return unless response.status == 200

      save_counters(response.body, account.id)
    end

    private

    def save_counters(body, account_id)
      body.each do |counter|
        cr = Counter.find_or_initialize_by(external_id: counter['counterId'])
        cr.attributes = {
          account_id:,
          counter_name: counter['counterName'],
          serial_code: counter['serialCode'],
          service_name: counter['serviceName'],
          service_group: counter['serviceGroup'],
          last_check: counter['lastCheck']
        }
        cr.save!
      rescue StandardError => e
        Rails.logger.warn "User importer error #{account.id} #{e}"
        next
      end
    end
  end
end
