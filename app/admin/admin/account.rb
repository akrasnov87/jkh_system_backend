ActiveAdmin.register Account, namespace: :admin do
  menu priority: 1
  permit_params :phone
  actions :all, except: %i(create new destroy)
  batch_action :destroy, false

  controller do
    def scoped_collection
      Account.includes(:account_users).where(company: current_user.companies)
    end

    def index
      @push_templates = PushTemplate.all
      super
    end
  end

  index download_links: false do
    selectable_column
    id_column
    column :number
    column :address
    column :full_name
    column :house
    column :phone
    column :company do |account|
      I18n.t("companies.#{account.company}")
    end
    column :app do |account|
      account.account_users.any?
    end
  end

  show do
    attributes_table do
      row :id
      row :external_id
      row :number
      row :date_begin
      row :date_end
      row :address
      row :full_name
      row :company do |account|
        I18n.t("companies.#{account.company}")
      end
      row :phone
      row :apart_name
      row :apart_name_ext
      row :house
      row :counters
    end
  end

  action_item :update_client, only: :index do
    link_to 'Обновить Абонентов', update_client_admin_accounts_path, class: 'action-item-button'
  end

  collection_action :update_client do
    Red.keys('user_id-*').map { |k| Red.del(k) }
    Red.keys('account_id-*').map { |k| Red.del(k) }
    redirect_to admin_accounts_path, notice: 'Обновлено'
  end

  action_item :move_to_staff, only: :index do
    link_to 'Обращения', move_to_staff_admin_accounts_path, class: 'action-item-button' if current_user.admin? || current_user.super_admin?
  end

  collection_action :move_to_staff do
    redirect_to staff_tickets_path
  end

  filter :number
  filter :address
  filter :full_name
  filter :house, as: :select, collection: proc { Account.where(company: current_user.companies).pluck(:house).uniq },
                 include_blank: true, input_html: { multiple: false, data: { controller: 'slim' } }
  filter :company, as: :select, collection: proc {
                                              current_user.companies.compact.map do |k|
                                                [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
                                              end
                                            }
  filter :phone
  filter :where_account_users, label: 'Приложение', as: :select, collection: [%w(Есть yes), %w(Нет no)]

  action_item :fetch_status, only: :show do
    link_to 'Обновить', fetch_status_admin_account_path(resource), method: :post, class: 'action-item-button'
  end

  member_action :fetch_status, method: :post do
    Red.del("account_id-#{resource.id}-counters")
    resource.counters.destroy_all
    AisImporter::Accounts.new(resource.company).account_by_external_id(resource.external_id)
    redirect_to admin_account_path(resource), notice: 'Обновлено'
  end
end
