ActiveAdmin.register Reward, namespace: :admin do
  menu priority: 5, parent: 'Информация по УК'
  permit_params :body, :title, :company, attachments_attributes: %i(id file _destroy)
  batch_action :destroy, false

  controller do
    def scoped_collection
      Reward.where(company: current_user.companies)
    end

    def create
      resource = ::Reward.create(params.permit!['reward'].except('attachments'))
      file = params['reward']['attachments']
      resource.attachments.destroy_all if file.present?
      AttachmentCreateService.call(resource, file) if file.present?
      redirect_to admin_reward_path(resource)
    end
  end

  filter :company, as: :select, collection: proc {
                                              current_user.companies.compact.map do |k|
                                                [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
                                              end
                                            }
  filter :body
  filter :title

  index do
    column :id
    column :company do |notification|
      I18n.t("companies.#{notification.company}") if notification.company
    end
    column :title
    column :body
    actions
  end

  show do
    attributes_table do
      row :title
      row :body
      row :company do |notification|
        I18n.t("companies.#{notification.company}") if notification.company
      end
      row :created_at
      row :updated_at
      row :attachments do |reward|
        reward.attachments.map do |attachment|
          link_to(attachment.file.filename, attachment.url)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
      f.input :title
      f.input :body
      f.has_many :attachments, allow_destroy: true do |a|
        a.input :file, as: :file, hint: a.object.file.present? ? a.object.file.filename.to_s : content_tag(:span, '')
      end
    end
    f.actions
  end
end
