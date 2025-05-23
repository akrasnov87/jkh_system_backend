module MobileApi
  module V1
    class Tickets < Grape::API
      resources :tickets do # rubocop:disable Metrics/BlockLength
        desc 'Список собственных Обращение', {
          is_array: true,
          entity: MobileApi::Entities::TicketForList
        }

        get '/' do
          authenticate!
          MobileApi::Entities::TicketForList.represent(
            current_user.tickets.order(updated_at: :desc).includes(:account)
          )
        end

        desc 'Создать обращение', consumes: ['multipart/form-data']
        params do
          requires :account_id, type: Integer
          requires :subject, type: String
          requires :description, type: String
          optional :attachments, type: Array do
            optional :file, type: File, documentation: { param_type: 'formData', data_type: 'file' }
          end
        end

        post '/' do
          authenticate!
          ticket = current_user.tickets.create(params.except(:attachments).merge(sla_started_at: Time.current))
          params[:attachments]&.each do |hash|
            file = OpenStruct.new(hash)
            AttachmentCreateService.call(ticket, file)
          end
          MobileApi::Entities::Ticket.represent(ticket)
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          Rails.logger.debug "Save tickets error #{e}"
        end

        desc 'Закрыть обращение'
        params do
          requires :ticket_id
        end

        put '/:ticket_id/close' do
          authenticate!
          ticket = current_user.tickets.find(params[:ticket_id])
          ticket.close!
          MobileApi::Entities::Ticket.represent(ticket)
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          Rails.logger.debug "Save tickets error #{e}"
        end

        desc 'Ответ на обращение'
        params do
          requires :ticket_id, type: Integer
          requires :subject, type: String
          requires :description, type: String
          optional :attachments, type: Array do
            optional :file, type: File, documentation: { param_type: 'formData', data_type: 'file' }
          end
        end

        post '/:ticket_id/replies' do
          authenticate!
          ticket = current_user.tickets.find(params[:ticket_id])
          ticket.update(status: :pending, sla_started_at: Time.current)
          reply = ticket.replies.create(
            subject: params[:subject],
            description: params[:description],
            user: current_user
          )
          params[:attachments]&.each do |hash|
            file = OpenStruct.new(hash)
            AttachmentCreateService.call(reply, file)
          end
          MobileApi::Entities::Ticket.represent(ticket)
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          Rails.logger.debug "Save tickets error #{e}"
        end

        desc 'Обращение по ID'
        params do
          requires :id, type: Integer
        end

        get '/:id' do
          authenticate!
          ticket = current_user.tickets.find_by(id: params[:id])
          MobileApi::Entities::Ticket.represent(ticket)
        end
      end
    end
  end
end
