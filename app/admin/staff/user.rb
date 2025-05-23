ActiveAdmin.register User, namespace: :staff do
  menu false
  config.batch_actions = false
  actions :all, except: %i(create new edit destroy)

  index download_links: false do
    selectable_column
    id_column
    column :full_name
    column :phone
    column :created_at
    actions
  end

  filter :full_name
  filter :phone

  show do
    attributes_table do
      row :full_name
      row :phone
      row :created_at
      row :accounts
    end
  end

  action_item :fetch_status, only: :show do
    link_to 'Обновить привязку номера', fetch_status_staff_user_path(resource), method: :post, class: 'action-item-button'
  end

  member_action :fetch_status, method: :post do
    Red.del("user_id-#{current_user.id}")
    ::Accounts::ImportByPhoneWorker.perform_async(resource.id)
    redirect_to staff_user_path(resource), notice: 'Обновлено'
  end
end
