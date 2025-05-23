ActiveAdmin.register CompanyDetail, namespace: :super_admin do
  permit_params :name, :address, :company, :inn, :kpp, :bill_type, :bill_number, :bank_name, :bik, :bill_cor

  form do |f|
    f.inputs do
      f.input :company, as: :select, collection: CompanyDetail.companies.map { |k, _v| [I18n.t("companies.#{k}"), k] }
      f.input :name
      f.input :address
      f.input :inn
      f.input :kpp
      f.input :bill_type
      f.input :bill_number
      f.input :bank_name
      f.input :bik
      f.input :bill_cor
    end
    f.actions
  end

  filter :company, as: :select, collection: CompanyDetail.companies.map { |k, v| [I18n.t("companies.#{k}"), v] }
end
