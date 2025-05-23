namespace :tickets do
  desc 'check sla'
  task check_sla: :environment do
    abort('abort sla check') if Time.zone.today.sunday? || Time.zone.today.saturday?

    Ticket.where('status IN (:statuses) AND sla_started_at < :sla_time',
                 statuses: Ticket.statuses.values_at('pending', 'open'),
                 sla_time: Time.current - 24.hours).find_each do |ticket|
      ticket.update(sla_expired: true)
    end
  end
end
