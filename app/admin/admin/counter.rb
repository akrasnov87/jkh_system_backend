ActiveAdmin.register Counter, namespace: :admin do
  menu priority: 7
  actions :all, except: %i(create new edit destroy)
  batch_action :destroy, false

  controller do
    def scoped_collection
      Counter.includes(:counters_values, :account).where(accounts: { company: current_user.companies })
    end
  end

  index do
    selectable_column
    id_column
    column :external_id
    column :account
    column :counter_name
    column :serial_code
    column :service_name
    column :service_group
    column :last_check
  end

  filter :external_id
  filter :account_id
  filter :counter_name
  filter :serial_code
  filter :service_name
  filter :service_group
  filter :last_check

  show do
    attributes_table do
      row :id
      row :account
      row :counter_name
      row :serial_code
      row :service_name
      row :service_group
      row :last_check
      row :counters_values
    end
  end
end
