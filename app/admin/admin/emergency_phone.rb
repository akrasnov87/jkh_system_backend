ActiveAdmin.register EmergencyPhone, namespace: :admin do
  menu priority: 100, parent: 'Информация по УК'
  permit_params :number, :company

  filter :company, as: :select, collection: proc {
                                              current_user.companies.compact.map do |k|
                                                [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
                                              end
                                            }
  filter :number

  controller do
    def scoped_collection
      EmergencyPhone.where(company: current_user.companies)
    end
  end

  index do
    id_column
    column :company do |emergency_phone|
      I18n.t("companies.#{emergency_phone.company}")
    end
    column :number
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :number
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
    end
    f.actions
  end
end
