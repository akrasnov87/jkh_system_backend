ActiveAdmin.register User, namespace: :super_admin do
  menu priority: 2
  permit_params :phone, :email, :role, :password, :password_confirmationm, :full_name, :department_id, companies: []

  controller do
    def scoped_collection
      User.includes(:department, :account_users)
    end

    def update
      companies = params['user']['companies'].reject(&:empty?)
      params['user']['companies'] = companies
      super
    end
  end

  index do
    selectable_column
    id_column
    column :department
    column :email
    column :phone
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :app do |user|
      user.account_users.any?
    end
    actions
  end

  show do
    attributes_table do
      row :department
      row :role
      row :email
      row :phone
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

  filter :created_at
  filter :where_account_users, label: 'Приложение', as: :select, collection: [%w(Есть yes), %w(Нет no)]
  filter :email
  filter :phone
  filter :department
  filter :role
  filter :current_sign_in_at
  filter :sign_in_count

  form do |f|
    f.inputs do
      f.input :full_name if resource.employee?
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
      f.input :department_id, label: false, as: :select, collection: Department.all.map { |d| [d.name, d.id] },
                              include_blank: false
      f.input :role, as: :select, collection: User.roles.keys.map { |r| [I18n.t("activerecord.attributes.user.roles.#{r}"), r] }
      f.input :companies, as: :check_boxes, multiple: true, collection: Account.companies.map { |k, _v| [I18n.t("companies.#{k}"), k] }
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
