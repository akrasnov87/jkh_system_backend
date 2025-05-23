module AisImporter
  class CountersValues
    attr_reader :company

    def initialize(company)
      @company = company
    end

    def by_year(counter, year)
      response = AisApiService.counters_values_by_year(counter.external_id, year, company)

      return unless response.status == 200

      save_counters_values(response.body, counter.id)
    end

    private

    def save_counters_values(body, counter_id)
      body.each do |value|
        save_counters_value(value, counter_id)
      end
    end

    def save_counters_value(value, counter_id)
      cv = CountersValue.find_or_initialize_by(
        counter_id:,
        year: value['periodYear'],
        month: value['periodMonth']
      )
      cv.val = value['val']
      cv.save!
    end
  end
end
