module Counters
  class ImportCounterValuesWorker
    include Sidekiq::Job
    sidekiq_options queue: 'counters', retry: false

    def perform(counter_id, year)
      counter = Counter.find(counter_id)
      AisImporter::CountersValues.new(counter.account.company).by_year(counter, year)
      AisImporter::CountersValues.new(counter.account.company).by_year(counter, year - 1)
    end
  end
end
