ActiveAdmin.register ServiceWork, namespace: :admin do
  permit_params :name, :service_category_id, :company, :position
  menu priority: 10, parent: 'Услуги'
  batch_action false

  controller do
    def scoped_collection
      ServiceWork.where(company: current_user.companies)
    end
  end

  filter :company, as: :select, collection: proc {
    current_user.companies.compact.map do |k|
      [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
    end
  }

  index do
    id_column
    column :service_category
    column :name
    column :company do |service_category|
      I18n.t("companies.#{service_category.company}")
    end
    column :position
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :position
      f.input :service_category, as: :select, collection: ServiceCategory.all
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
    end
    f.actions
  end
end
