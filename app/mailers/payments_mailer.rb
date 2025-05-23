class PaymentsMailer < ApplicationMailer
  def exporter(to_email, file, filename)
    attachments[filename] = File.read(file.path)
    mail(to: to_email, subject: "СБП Оплаты за #{Time.zone.yesterday}")
  end
end
