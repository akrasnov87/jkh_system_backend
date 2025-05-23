ActiveAdmin.register PushTemplate, namespace: :staff do
  menu if: proc {
    current_user.admin? || current_user.department&.value == 'support' || current_user.super_admin?
  }, priority: 3
  permit_params :body, :title, :company, :url_action
  batch_action :destroy, false

  filter :company, as: :select, collection: proc { current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] } }
  filter :title
  filter :body

  show do
    attributes_table do
      row :url_action do |push_template|
        I18n.t("notifications.url_actions.#{push_template.url_action}") if push_template.url_action.present?
      end
      row :company do |push_template|
        I18n.t("companies.#{push_template.company}")
      end
      row :title
      row :body
    end
  end

  index do
    id_column
    column :company do |push_template|
      I18n.t("companies.#{push_template.company}")
    end
    column :title
    column :body
    column :url_action do |push_template|
      I18n.t("notifications.url_actions.#{push_template.url_action}") if push_template.url_action.present?
    end
    column :created_at
  end

  controller do
    def scoped_collection
      PushTemplate.where(company: current_user.companies)
    end
  end

  form do |f|
    f.inputs do
      f.input :url_action, as: :select, collection: Notification.url_actions.map { |k, _v| [I18n.t("notifications.url_actions.#{k}"), k] }
      f.input :title
      f.input :body
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
    end
    f.actions
  end
end
