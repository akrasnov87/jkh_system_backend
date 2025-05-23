ActiveAdmin.register Payment, namespace: :admin do
  menu priority: 5
  config.batch_actions = false
  actions :all, except: %i(create new edit destroy)
  batch_action :destroy, false

  controller do
    def scoped_collection
      Payment.includes(:account).where(accounts: { company: current_user.companies })
    end
  end

  filter :created_at
  filter :account, as: :select, collection: -> {
    Account.where(company: current_user.companies).limit(5).map { |a| ["#{a.number} #{a.address}"] }
  }, include_blank: true, input_html: { multiple: false, data: { controller: 'accounts' } }
  filter :status, as: :select,
                  collection: [['Отменен', Payment.statuses[:revoked]], ['Оплачен', Payment.statuses[:paid]], ['Создан', Payment.statuses[:created]]]

  index do
    id_column
    column :account
    column :status do |payment|
      I18n.t("payments.statuses.#{payment.status}")
    end
    column :order_sum
    column :created_at
  end

  show do
    attributes_table do
      row :account
      row :status do |payment|
        I18n.t("payments.statuses.#{payment.status}")
      end
      row :order_id
      row :rq_uid
      row :order_form_url
      row :order_sum
      row :id_qr
      row :kind
      row :created_at
      row :updated_at
    end
  end

  action_item :fetch_status, only: :show do
    link_to 'Обновить Статус', fetch_status_admin_payment_path(resource), method: :post
  end

  action_item :revoke, only: :show do
    link_to 'Отменить', revoke_admin_payment_path(resource), method: :post, data: { confirm: 'Вы уверены?' }
  end

  member_action :fetch_status, method: :post do
    Payments::Status.new(resource).call
    redirect_to admin_payment_path(resource), notice: 'Обновлено'
  end

  member_action :revoke, method: :post do
    Payments::Revoke.new(resource).call
    redirect_to admin_payment_path(resource), notice: 'Отменена'
  end
end
