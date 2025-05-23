ActiveAdmin.register UsefulContact, namespace: :admin do
  menu priority: 7, parent: 'Информация по УК'
  permit_params :name, :number, :company
  batch_action :destroy, false

  controller do
    def scoped_collection
      UsefulContact.where(company: current_user.companies)
    end
  end

  filter :company, as: :select, collection: proc {
                                              current_user.companies.compact.map do |k|
                                                [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
                                              end
                                            }
  filter :name
  filter :number

  index do
    column :id
    column :company do |notification|
      I18n.t("companies.#{notification.company}") if notification.company
    end
    column :name
    column :number
    actions
  end

  show do
    attributes_table do
      row :name
      row :number
      row :company do |notification|
        I18n.t("companies.#{notification.company}") if notification.company
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
      f.input :name
      f.input :number
    end
    f.actions
  end
end
