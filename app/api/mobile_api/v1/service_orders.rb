module MobileApi
  module V1
    class ServiceOrders < Grape::API
      resources :service_orders do
        desc 'Заявки на услуги', {
          is_array: true,
          entity: MobileApi::Entities::ServiceOrdersForList
        }

        params do
          optional :status, type: String, values: ServiceOrder.statuses.keys
        end

        get '/' do
          authenticate!
          service_orders = if ServiceOrder.statuses.key?(params[:status])
                             current_user.service_orders
                                         .where(status: params[:status]).order(created_at: :desc)
                                         .includes(:service_payments).limit(30)
                           else
                             current_user.service_orders.order(created_at: :desc).includes(:service_payments).limit(30)
                           end
          MobileApi::Entities::ServiceOrdersForList.represent(service_orders)
        end

        desc 'Создать заявку на услугу', consumes: ['multipart/form-data']
        params do
          requires :account_id, type: Integer
          requires :subject, type: String
          optional :description, type: String
          requires :service_category_id, type: Integer
          requires :service_work_id, type: Integer
          optional :attachments, type: Array do
            optional :file, type: File, documentation: { param_type: 'formData', data_type: 'file' }
          end
        end

        post '/' do
          authenticate!
          account = Account.find(params[:account_id])
          service_order = current_user.service_orders.create(
            params.except(:attachments)
                  .merge(
                    phone: current_user.phone,
                    number: account.number,
                    full_name: account.full_name,
                    company: account.company,
                    address: account.address
                  )
          )
          params[:attachments]&.each do |hash|
            file = OpenStruct.new(hash)
            AttachmentCreateService.call(service_order, file)
          end
          MobileApi::Entities::ServiceOrders.represent(service_order)
        rescue StandardError => e
          Rails.logger.warn "Save service order error #{e}"
          error!('System error', 500)
        end

        desc 'Переводит заявку в статус решена(все работы по ней выполнены)'
        params do
          requires :service_order_id
        end

        put '/:service_order_id/resolve' do
          authenticate!
          service_order = current_user.service_orders.find(params[:service_order_id])
          service_order.resolve!
          MobileApi::Entities::ServiceOrders.represent(service_order)
        rescue StandardError => e
          Rails.logger.warn "Close service_orders error #{e}"
          error!('System error', 500)
        end

        desc 'Ответ на заявку на услугу'
        params do
          requires :service_order_id, type: Integer
          requires :subject, type: String
          requires :description, type: String
          optional :attachments, type: Array do
            optional :file, type: File, documentation: { param_type: 'formData', data_type: 'file' }
          end
        end

        post '/:service_order_id/replies' do
          authenticate!
          service_order = current_user.service_orders.find(params[:service_order_id])
          reply = service_order.service_replies.create(
            subject: params[:subject],
            description: params[:description],
            user: current_user
          )
          params[:attachments]&.each do |hash|
            file = OpenStruct.new(hash)
            AttachmentCreateService.call(reply, file)
          end
          MobileApi::Entities::ServiceOrders.represent(service_order)
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          Rails.logger.warn "Save service_order error #{e}"
        end

        desc 'Заявка на услугу по ID'
        params do
          requires :id, type: Integer
        end

        get '/:id' do
          authenticate!
          service_order = current_user.service_orders.find_by(id: params[:id])
          MobileApi::Entities::ServiceOrders.represent(service_order)
        end

        desc 'Отменить и закрыть заявку на услугу работает только для не оплаченных услуг'
        params do
          requires :service_order_id
        end

        put '/:service_order_id/close' do
          authenticate!
          service_order = current_user.service_orders.find(params[:service_order_id])
          service_order.close! unless service_order.paid?
          MobileApi::Entities::ServiceOrders.represent(service_order)
        rescue StandardError => e
          Rails.logger.warn "Close service_orders error #{e}"
          error!('System error', 500)
        end
      end
    end
  end
end
