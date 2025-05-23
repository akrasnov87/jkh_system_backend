ActiveAdmin.register Ticket, namespace: :staff do
  menu priority: 1
  config.batch_actions = false
  permit_params :department_id

  controller do
    def scoped_collection
      if current_user&.department&.value == 'support' || current_user.admin? || current_user.super_admin?
        Ticket.includes(:user, :account, :department).where(accounts: { company: current_user.companies })
      else
        Ticket.includes(:user, :account, :department).where(department_id: current_user.department_id)
              .where(accounts: { company: current_user.companies })
      end
    end

    def action_methods
      if current_user&.super_admin?
        super - %w(new create edit)
      else
        super - %w(edit destroy new create)
      end
    end

    def find_collection(options = {})
      super.reorder(created_at: :desc)
    end
  end

  index(row_class: -> (ticket) { ticket.row_color }) do
    id_column
    column :company do |ticket|
      I18n.t("companies.#{ticket.account.company}")
    end
    column :department
    column :subject
    column :description
    column :status do |ticket|
      I18n.t("activerecord.attributes.ticket.statuses.#{ticket.status}")
    end
    column :full_name do |ticket|
      ticket.account.full_name
    end
    column :address do |ticket|
      link_to ticket.account.address,
              controller: :accounts,
              action: 'show',
              id: ticket.account.id.to_s
    end
    column :created_at
  end

  action_item :move_to_admin, only: :index do
    link_to 'Админка', move_to_admin_staff_tickets_path, class: 'action-item-button' if current_user.admin? || current_user.super_admin?
  end

  collection_action :move_to_admin do
    redirect_to admin_accounts_path
  end

  filter :where_account_address, as: :string, label: 'Адрес'
  filter :where_account_number, as: :string, label: 'Лицевой счет'
  filter :where_account_full_name, as: :string, label: 'ФИО'
  filter :status, as: :select, collection: Ticket.statuses.map { |k, v| [I18n.t("activerecord.attributes.ticket.statuses.#{k}"), v] },
                  input_html: { multiple: true, data: { controller: 'slim' } }
  filter :origin, as: :select, collection: Ticket.origins.map { |k, v| [I18n.t("activerecord.attributes.ticket.origins.#{k}"), v] },
                  input_html: { multiple: true, data: { controller: 'slim' } }
  filter :department, as: :select, collection: Department.all
  filter :subject
  filter :description
  filter :created_at

  show do |ticket|
    attributes_table do
      row :department do
        active_admin_form_for [:staff, resource], builder: ActiveAdmin::FormBuilder do |f|
          div(class: 'grid grid-cols-3 gap-4') do
            f.inputs do
              div do
                f.input :department_id, label: false, as: :select, collection: Department.all.map { |d| [d.name, d.id] },
                                        include_blank: false, input_html: { value: ticket.department_id }
              end
            end
            f.actions do
              div do
                f.action :submit, as: :button, label: 'Отправить'
              end
            end
          end
        end
      end
      row :full_name do
        ticket.account.full_name
      end
      row :phone do
        ticket.user.phone
      end
      row :address do
        ticket.account.address
      end
      row :company do
        I18n.t("companies.#{ticket.account.company}")
      end
      row :origin do
        I18n.t("activerecord.attributes.ticket.origins.#{ticket.origin}")
      end
      row :status do
        I18n.t("activerecord.attributes.ticket.statuses.#{ticket.status}")
      end
      row :created_at
      row :updated_at
      row :subject
      row :description
      row :files do
        if ticket.attachments.any?
          div do
            ul do
              ticket.attachments.each do |attachment|
                li do
                  link_to(attachment.file.filename, attachment.url)
                end
              end
            end
          end
        end
      end
    end

    if resource.replies.any?
      panel 'Сообщения' do
        attributes_table_for ticket do
          ticket.replies.order(created_at: :asc).each.with_index(1) do |reply, index|
            row "№#{index}" do
              div do
                "От #{I18n.t("replies.kinds.#{reply.kind}")} #{reply.user.full_name || reply.user.email} #{reply.created_at.strftime('%d-%m-%Y %I:%M:%S')}"
              end
              div do
                reply.description
              end
              if reply.attachments.any?
                div do
                  ul do
                    reply.attachments.each do |attachment|
                      li do
                        link_to(attachment.file.filename, attachment.url)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    unless resource.replies.staff.last&.description&.include?('Спасибо за ваще обращение, были рады вам помочь!')
      active_admin_form_for [:staff, resource.replies.build], builder: ActiveAdmin::FormBuilder do |f|
        f.inputs 'Новый ответ' do
          f.input :ticket_id, input_html: { value: resource.id }, as: :hidden
          f.input :user_id, input_html: { value: current_user.id }, as: :hidden
          f.input :kind, input_html: { value: :staff }, as: :hidden
          f.input :subject, required: true, input_html: { value: resource.subject }
          f.input :description, required: true, input_html: { class: 'autogrow', rows: 5 }
          f.has_many :attachments, allow_destroy: true do |a|
            div do
              "Доступные форматы вложений #{Attachment::EXTENSION_WHITE_LIST.join(', ')}"
            end
            a.input :file, as: :file, hint: a.object.file.present? ? a.object.file.filename.to_s : content_tag(:span, '')
          end
        end
        f.actions do
          if resource.close?
            f.action :submit, as: :button, label: 'Поблагодарить', button_html:
              {
                name: :status, value: :close,
                'data-confirm'.to_sym => 'Сообщение будет отправлено жильцу. Вы уверены?'
              }
          else
            f.action :submit, as: :button, label: 'Ответить', button_html:
              {
                name: :status, value: :replayed,
                'data-confirm'.to_sym => 'Сообщение будет отправлено жильцу. Вы уверены?'
              }
            f.action :submit, as: :button, label: 'Ответить и Закрыть', button_html: {
              name: :status, value: :resolved,
              'data-confirm'.to_sym => 'Сообщение будет отправлено жильцу. Вы уверены?'
            }
          end
        end
      end
    end
  end
end
