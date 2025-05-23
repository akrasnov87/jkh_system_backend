ActiveAdmin.register User, namespace: :admin do
  menu false
  permit_params :full_name
  actions :all, except: %i(create new destroy)
  batch_action :destroy, false

  controller do
    def update
      companies = params['user']['companies'].reject(&:empty?)
      params['user']['companies'] = companies
      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :phone
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :phone
      row :accounts
      row :full_name
      row :phone
      row :companies do |user|
        user.companies.map { |k| I18n.t("companies.#{k}") }
      end
      row :sms_code_failed_attempts
      row :sms_code
      row :sign_in_count
      row :created_at
      row :updated_at
    end
  end

  filter :email
  filter :phone
  filter :role
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :full_name if resource.employee?
    end
    f.actions
  end

  action_item :refresh_user_accounts, only: :show do
    link_to 'Обновить Лицевые счета', refresh_user_accounts_admin_user_path(resource), method: :post, class: 'action-item-button'
  end

  member_action :refresh_user_accounts, method: :post do
    Red.del("user_id-#{current_user.id}")
    ::Accounts::ImportByPhoneWorker.perform_async(current_user.id)
    redirect_to admin_user_path(resource), notice: 'Обновлено'
  end
end
