ActiveAdmin.register Department, namespace: :super_admin do
  menu priority: 101
  permit_params :name, :value
end
