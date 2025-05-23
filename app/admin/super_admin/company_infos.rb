ActiveAdmin.register CompanyInfo, namespace: :super_admin do
  menu priority: 100
  permit_params :address, :company, :email, :phone, :working_schedules, attachments_attributes: %i(id file _destroy)

  filter :company, as: :select, collection: proc { current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] } }
  filter :number

  index do
    id_column
    column :company do |emergency_phone|
      I18n.t("companies.#{emergency_phone.company}")
    end
    column :email
    column :phone
    column :address
    column :working_schedules
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :company
      row :email
      row :phone
      row :address
      row :working_schedules
      row :created_at
      row :updated_at
      row :attachments do |company_info|
        company_info.attachments.map do |attachment|
          link_to(attachment.file.filename, attachment.url)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
      f.input :address
      f.input :email
      f.input :phone
      f.input :working_schedules
      f.has_many :attachments, allow_destroy: true do |a|
        a.input :file, as: :file, hint: a.object.file.present? ? a.object.file.filename.to_s : content_tag(:span, '')
      end
    end
    f.actions
  end
end
