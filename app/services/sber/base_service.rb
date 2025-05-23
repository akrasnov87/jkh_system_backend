module Sber
  class BaseService
    attr_reader :company

    def initialize(company = nil)
      @company = company
    end

    def connection
      NotImplementedError
    end

    def client_key
      cert.key
    end

    def client_cert
      cert.certificate
    end

    def cert
      OpenSSL::PKCS12.new(p12_file, ENV['SBER_CERT_PASS'])
    end

    def p12_file
      File.binread(Rails.root.join("cert/#{company}.p12"))
    end

    def ssl
      {
        client_key:,
        client_cert:,
        ca_file: ENV['SBER_CA_FILE']
      }
    end
  end
end
