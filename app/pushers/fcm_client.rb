class FcmClient
  def send_push(token, template)
    if Rails.env.development? || Rails.env.test?
      Rails.logger.info("\n#{token}: #{template.body}\n")
    else
      fcm_sender.send_v1(fcm_options(token, template))
    end
  end

  private

  def fcm_options(token, template)
    {
      token:,
      data: { payload: (template.try(:data) || {}).to_json },
      notification: { title: template.title, body: template.body }
    }
  end

  def fcm_sender
    @fcm = FCM.new(
      'cert/firebase.json',
      ENV['FIREBASE_PROJECT_ID']
    )
  end
end
