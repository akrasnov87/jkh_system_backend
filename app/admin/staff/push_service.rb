ActiveAdmin.register_page 'push_service', namespace: :staff do
  menu if: proc {
    current_user.admin? || current_user.department&.value == 'support' || current_user.super_admin?
  }, label: 'Сервис Уведомлений', priority: 3
  content title: 'Сервис Уведомлений' do
    div(class: 'grid grid-cols-2 gap-2') do
      div do
        panel 'Уведомления  на Компанию' do
          active_admin_form_for :push_notification, url: :staff_push_service_send_notification, builder: ActiveAdmin::FormBuilder do |f|
            f.inputs do
              f.input :company, label: 'Компания',
                                as: :select,
                                collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] },
                                include_blank: false, input_html: { multiple: true, data: { controller: 'slim' } }
              f.input :push_template_id, as: :select, collection: PushTemplate.by_company(current_user).map { |pt| [pt.title, pt.id] },
                                         include_blank: false, input_html: { multiple: false, data: { controller: 'slim' } }
            end
            f.actions do
              f.action :submit, label: 'Отправить сообщение',
                                button_html: { 'data-confirm'.to_sym => 'Сообщение будет отправлено жильцам. Вы уверены?' }
            end
          end
        end
      end
      div do
        panel 'Уведомления  на Дом' do
          active_admin_form_for :push_notification, url: :staff_push_service_send_notification, builder: ActiveAdmin::FormBuilder do |f|
            f.inputs do
              f.input :house, label: 'Дом',
                              collection: Account.where(company: current_user.companies).pluck(:house).uniq,
                              include_blank: false, input_html: { multiple: true, data: { controller: 'slim' } }
              f.input :push_template_id, as: :select, collection: PushTemplate.by_company(current_user).map { |pt| [pt.title, pt.id] },
                                         include_blank: false, input_html: { multiple: false, data: { controller: 'slim' } }
            end
            f.actions do
              f.action :submit, label: 'Отправить сообщение',
                                button_html: { 'data-confirm'.to_sym => 'Сообщение будет отправлено жильцам. Вы уверены?' }
            end
          end
        end
      end
      div do
        panel 'Уведомления по адресу' do
          active_admin_form_for :push_notification, url: :staff_push_service_send_notification, builder: ActiveAdmin::FormBuilder do |f|
            f.inputs do
              f.input :accounts_ids, label: 'Номер Лицевого счета',
                                     collection: Account.active.where(company: current_user.companies).limit(5).map { |a|
                                                   ["#{a.number} #{a.address}"]
                                                 },
                                     include_blank: false, input_html: { multiple: true, data: { controller: 'accounts' } }
              f.input :push_template_id, as: :select, collection: PushTemplate.by_company(current_user).map { |pt| [pt.title, pt.id] },
                                         include_blank: false, input_html: { multiple: false, data: { controller: 'slim' } }
            end
            f.actions do
              f.action :submit, label: 'Отправить сообщение',
                                button_html: { 'data-confirm'.to_sym => 'Сообщение будет отправлено жильцам. Вы уверены?' }
            end
          end
        end
      end
    end
  end

  page_action :send_notification, method: :post do
    hash_params = params.permit!['push_notification'].to_hash.deep_symbolize_keys
    accounts_ids = if hash_params[:company]
                     Account.where(company: hash_params[:company]).pluck(:id)
                   elsif hash_params[:house]
                     Account.where(house: hash_params[:house]).pluck(:id)
                   elsif hash_params[:accounts_ids]
                     hash_params[:accounts_ids]
                   end
    if accounts_ids
      Accounts::SendPushNotifications
        .perform_async(accounts_ids, hash_params[:push_template_id], current_user.email)
    end
    redirect_to staff_push_service_path, notice: 'Ваш сообщение отправлено'
  end
end
