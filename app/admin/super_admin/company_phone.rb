ActiveAdmin.register CompanyPhone, namespace: :super_admin do
  menu priority: 100
  permit_params :number, :name
end
