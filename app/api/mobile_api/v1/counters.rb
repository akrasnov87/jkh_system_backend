module MobileApi
  module V1
    class Counters < Grape::API
      resources :counters do # rubocop:disable Metrics/BlockLength
        desc 'Список счетчиков по лицевому счету', {
          is_array: true,
          entity: MobileApi::Entities::Counters
        }
        params do
          requires :account_id, type: String
        end
        get '/' do
          authenticate!
          account = current_user.accounts.find(params[:account_id])
          unless Red.get("account_id-#{account.id}-counters")
            Red.setex("account_id-#{account.id}-counters", 24.hours.to_i, 1)
            AisImporter::Counters.new(account.company).by_account(account)
          end
          counters = current_user.accounts.find_by(id: params[:account_id]).counters

          year = Date.current.year
          counters.each do |counter|
            unless Red.get("counter_id-#{counter.id}-#{year}-counters_values").present?
              Red.setex("counter_id-#{counter.id}-#{year}-counters_values", 24.hours.to_i, 1)
              ::Counters::ImportCounterValuesWorker.perform_async(counter.id, year)
            end
          end
          MobileApi::Entities::Counters.represent(counters)
        end

        desc 'Данные по счетчику', {
          entity: MobileApi::Entities::Counter
        }
        params do
          requires :id, type: String, desc: 'id счетчика'
          optional :year, type: String, desc: 'Год для показаний, если оставить пустым будет текущий'
        end
        get '/:id' do
          authenticate!
          counter = current_user.counters.find(params[:id])
          year = params[:year] || Date.current.year

          MobileApi::Entities::Counter.represent(counter, year:)
        end

        desc 'Обновить label счетчика', {
          entity: MobileApi::Entities::Counter
        }
        params do
          requires :label, type: String
          requires :id, type: String
        end
        put '/:id' do
          authenticate!
          counter = current_user.counters.find_by(id: params[:id])
          counter.update!(label: params[:label])
          MobileApi::Entities::Counter.represent(counters)
        end

        desc 'Перадать показания счетчиков', {
          entity: MobileApi::Entities::Counter
        }
        params do
          requires :counter_id, type: String, desc: 'ID счетчика'
          requires :year, type: String, desc: 'Год'
          requires :month, type: String, desc: 'Месяц'
          requires :val, type: String, desc: 'Число с плавающей точкой'
        end
        post '/' do
          authenticate!
          counter = current_user.counters.find_by(id: params[:counter_id].scan(/\d+/).join.to_i)

          if counter.counters_values.first&.val && counter.counters_values.first.val > params[:val].to_f
            error!({ errors: { 'counter[val]' => ['Показание меньше предыдущего'] } }, 406)
          end

          current_date = Date.current
          last_six_months = (1..6).map { |i| current_date - i.months }
          empty_all_values = last_six_months.all? do |date|
            year = date.year
            month = date.month

            !CountersValue.where(counter_id: counter.id, year:, month:).exists?
          end

          if empty_all_values
            error!(
              { errors: { 'counter[val]' => ['Уважаемый абонент ваш период сдачи показаний превышает 6 месяцев, для актуализации данных обратитесь в управляющую компанию'] } }, 422
            )
          end

          counter_value = CountersValue.find_or_initialize_by(
            counter_id: counter.id,
            year: params[:year],
            month: params[:month]
          )
          counter_value.val = params[:val]
          if counter_value.save!
            AisApiService.send_counter_value(counter.external_id, counter.company, counter_value)
            MobileApi::Entities::Counter.represent(counter, year: Date.current.year)
          end
        end
      end
    end
  end
end
