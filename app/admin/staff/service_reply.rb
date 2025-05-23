ActiveAdmin.register ServiceReply, namespace: :staff do
  menu false
  permit_params :subject, :description, :service_order_id, :user_id, :kind, :attachments,
                attachments_attributes: %i(id file _destroy)

  config.batch_actions = false
  actions :all, except: %i(edit destroy)

  controller do
    def create
      resource = ::ServiceReply.create(params.permit!['service_reply'])
      redirect_to staff_service_order_path(resource.service_order)
    end
  end
end
