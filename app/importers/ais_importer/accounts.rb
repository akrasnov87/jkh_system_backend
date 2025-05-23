module AisImporter
  class Accounts
    attr_reader :company

    def initialize(company)
      @company = company
    end

    def by_page
      page = 1
      loop do
        response = AisApiService.accounts_by_page(page, company)
        page += 1
        break if response.status != 200
        break if response.body.count == 0
        break if page > 10

        save_accounts(response.body)
        sleep(30)
      rescue StandardError
        Rails.logger.warn "User importer error #{response.body} error status #{response.status}"
        break
      end
    end

    def by_phone(phone, user)
      response = AisApiService.accounts_by_phone(phone, company)

      return unless response.status == 200

      save_accounts(response.body, user)
    end

    def account_by_external_id(external_id)
      response = AisApiService.account_by_external_id(external_id, company)

      return unless response.status == 200

      save_account(response.body)
    end

    private

    def save_account(account)
      acc = Account.send(company).find_or_initialize_by(external_id: account['id'])
      acc.attributes = {
        apart_name: account['typeAddrAppartName'],
        apart_name_ext: account['typeAddrAppartNameExt'],
        number: account['number'],
        date_begin: account['dateBeg'],
        date_end: account['dateEnd'],
        house: account['addressHouse'],
        full_name: account['peopleName'],
        address: account['addressAppart'],
        phone: account['phone']
      }
      acc.save!
      acc
    end

    def save_accounts(body, user = nil)
      body.each do |account|
        account = save_account(account)
        ::AddedAccountToUser.new(user, account).call if user && account
      rescue StandardError => e
        Rails.logger.warn "User importer error #{account.id} #{e}"
        next
      end
    end
  end
end
