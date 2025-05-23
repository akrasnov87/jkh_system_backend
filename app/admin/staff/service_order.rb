ActiveAdmin.register ServiceOrder, namespace: :staff do
  permit_params :phone, :order_sum
  menu priority: 2
  batch_action false
  actions :all, except: %i(destroy)

  filter :number
  filter :status, as: :check_boxes, collection: ServiceOrder.statuses.map { |k, v| [I18n.t("service_orders.statuses.#{k}"), v] }
  filter :phone
  filter :full_name
  filter :subject
  filter :description
  filter :service_category
  filter :service_work
  filter :company, as: :select, collection: proc {
    current_user.companies.compact.map do |k|
      [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
    end
  }
  filter :created_at

  controller do
    def scoped_collection
      if current_user&.department&.value == 'payment_service' || current_user.super_admin?
        ServiceOrder
      else
        ServiceOrder.where(service_orders: { company: current_user.companies })
      end
    end

    def find_collection(options = {})
      super.reorder(created_at: :desc)
    end
  end

  index do
    id_column
    column :company do |service_order|
      I18n.t("companies.#{service_order.company}")
    end
    column :status do |service_order|
      I18n.t("service_orders.statuses.#{service_order.status}")
    end
    column :subject
    column :full_name
    column :address
    column :number
    column :created_at
  end

  show do |service_order|
    attributes_table do
      row :company do
        I18n.t("companies.#{service_order.company}")
      end
      row :account
      row :number
      row :status do
        I18n.t("service_orders.statuses.#{service_order.status}")
      end
      row :service_category
      row :service_work
      row :full_name
      row :phone
      row :address
      row :subject
      row :description
      row :files do
        if service_order.attachments.any?
          div do
            ul do
              service_order.attachments.each do |attachment|
                li do
                  link_to(attachment.file.filename, attachment.url)
                end
              end
            end
          end
        end
      end
      row :created_at
    end

    div do
      active_admin_form_for [:create_service_payment_staff, resource],
                            builder: ActiveAdmin::FormBuilder,
                            method: :post do |f|
        div(class: 'grid grid-cols-3 gap-4') do
          f.inputs do
            div do
              f.input :order_sum, label: false, input_html: { value: '', placeholder: 'Введите сумму для оплаты' }
            end
          end
          f.actions do
            div do
              f.action :submit, as: :button, label: 'Создать оплату', button_html:
                {
                  'data-confirm': 'Счет будет отправлено жильцу. Вы уверены?'
                }
            end
          end
        end
      end
    end

    if resource.service_payments.any?
      details class: 'payment_group' do
        summary class: 'cursor-pointer font-bold p-2 bg-gray-200 rounded-lg' do
          'Список оплат'
        end
        div class: 'p-4 bg-gray-100 rounded-lg mt-2' do
          service_order.service_payments.order(created_at: :desc).each do |service_payment|
            attributes_table_for service_payment do
              row 'ID' do
                div(class: 'flex justify-between') do
                  div do
                    service_payment.id
                  end
                  div(class: 'flex flex-row space-x-4') do
                    div do
                      unless service_payment.paid?
                        link_to('Обновить Статус', status_service_payment_staff_service_order_path(service_payment),
                                class: 'action-item-button bg-blue-700 text-stone-50', method: :put)
                      end
                    end
                    div do
                      unless service_payment.paid?
                        link_to('Удалить', destroy_service_payment_staff_service_order_path(service_payment),
                                class: 'action-item-button bg-red-600 text-stone-50',
                                method: :delete, data: { confirm: 'Вы уверены что хотите удалить оплату?' })
                      end
                    end
                  end
                end
              end
              row 'Сумма оплаты', :order_sum
              row 'Статус', :status do
                I18n.t("payments.statuses.#{service_payment.status}")
              end
              row 'Ссылка на оплату', :order_form_url
              row 'Создана', :created_at
            end
          end
        end
      end
    end
    details class: 'replies_group' do
      summary class: 'cursor-pointer font-bold p-2 bg-gray-200 rounded-lg' do
        'Переписка с собственником'
      end
      div class: 'p-4 bg-gray-100 rounded-lg mt-2' do
        if service_order.service_replies.any?
          attributes_table_for service_order do
            service_order.service_replies.order(created_at: :asc).each.with_index(1) do |reply, index|
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

      active_admin_form_for [:staff, resource.service_replies.build], builder: ActiveAdmin::FormBuilder do |f|
        f.inputs 'Новый ответ' do
          f.input :service_order_id, input_html: { value: resource.id }, as: :hidden
          f.input :user_id, input_html: { value: current_user.id }, as: :hidden
          f.input :kind, input_html: { value: :staff }, as: :hidden
          f.input :subject, required: true, input_html: { value: resource.subject }
          f.input :description, required: true, input_html: { class: 'autogrow', rows: 5 }
          f.has_many :attachments, allow_destroy: true do |a|
            a.input :file, as: :file, hint: a.object.file.present? ? a.object.file.filename.to_s : content_tag(:span, '')
          end
        end
        f.actions do
          f.action :submit, as: :button, label: 'Ответить', button_html:
            {
              'data-confirm'.to_sym => 'Сообщение будет отправлено жильцу. Вы уверены?'
            }
        end
      end
    end
  end

  member_action :status_service_payment, method: :put do
    service_payment = ServicePayment.find(params[:id])
    service_order = service_payment.service_order
    ServicePayments::Status.new(service_payment).call
  rescue StandardError => e
    Rails.logger.warn "Status service payment error #{e}"
  ensure
    redirect_to staff_service_order_path(service_order), notice: 'Статус обновлен'
  end

  member_action :destroy_service_payment, method: :delete do
    service_payment = ServicePayment.find(params[:id])
    service_order = service_payment.service_order
    service_payment = ServicePayments::Status.new(service_payment).call
    service_payment.destroy unless service_payment.paid?
  rescue StandardError => e
    Rails.logger.warn "Destroy service payment error #{e}"
  ensure
    redirect_to staff_service_order_path(service_order), notice: 'Оплата удалена'
  end

  member_action :create_service_payment, method: :post do
    ServicePayments::Creator.new(resource, { order_sum: params['service_order']['order_sum'] }).call
    resource.unpaid! if resource.paid?
  rescue StandardError => e
    Rails.logger.warn "Create service payment error #{e}"
  ensure
    redirect_to staff_service_order_path(resource)
  end

  form do |f|
    f.inputs do
      f.input :phone
    end
    f.actions
  end
end
