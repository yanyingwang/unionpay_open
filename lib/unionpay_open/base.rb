module UnionpayOpen
  Base = Class.new do
    class << self

      ENDPOINT = 'https://101.231.204.80:5000/gateway/api/'

      def faraday
        Faraday.new(ENDPOINT, :ssl => {:verify => false})
      end

      def sign(data)
        Base64.strict_encode64(
          @@pkcs12.key.sign(OpenSSL::Digest::SHA1.new,
                            Digest::SHA1.hexdigest(data)) )
      end

      def fixed_params
        { version: '5.0.0',
          encoding: 'UTF-8',
          txnTime: Time.now.strftime("%Y%m%d%H%M%S"),
          certId: @@pkcs12.certificate.serial.to_s,
          merId: @@merchant_no }
      end

    end
  end
end
