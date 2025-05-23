ActiveAdmin.register Reply, namespace: :staff do
  menu false
  permit_params :subject, :description, :ticket_id, :user_id, :kind, :attachments, :status,
                attachments_attributes: %i(id file _destroy)

  config.batch_actions = false
  actions :all, except: %i(edit destroy)

  controller do
    def create
      resource = ::Reply.create(params.permit!['reply'].except('status'))
      resource.ticket.send("#{params['status']}!")
      if params['status'] == 'close'
        resource.update(description: 'Спасибо за ваще обращение, были рады вам помочь!')
      else
        resource.ticket.update(sla_expired: false, sla_started_at: nil)
        push_template = OpenStruct.new({ title: 'У вас новое сообщение',
                                         body: 'Новый ответ на ваще обращение',
                                         data: { ticket_id: resource.ticket_id } })
        PushNotifiersService.new(resource.ticket.user_id, push_template, current_user.email).call
      end
      redirect_to staff_ticket_path(resource.ticket)
    end
  end
end
