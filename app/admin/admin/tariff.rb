ActiveAdmin.register Tariff, namespace: :admin do
  permit_params :name, :explanation, :company
  menu priority: 6, parent: 'Информация по УК'
  controller do
    def scoped_collection
      Tariff.where(company: current_user.companies)
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :explanation
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
    end
    f.actions
  end

  index do
    id_column
    column :company do |tariff|
      I18n.t("companies.#{tariff.company}")
    end
    column :name
    column :explanation
  end

  filter :name
  filter :explanation
  filter :company, as: :select, collection: proc {
                                              current_user.companies.compact.map do |k|
                                                [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
                                              end
                                            }
end
