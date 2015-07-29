require "unionpay_open/version"
require "unionpay_open/base"
require "unionpay_open/wap"
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/inflector'
require 'openssl'
require 'base64'
require 'faraday'



module UnionpayOpen
  cattr_accessor :pfx_file, :pfx_file_password, :ca_file, :merchant_no, :pkcs12, :x509_certificate
  class << self

    def config
      yield(self) if block_given?

      @@x509_certificate = OpenSSL::X509::Certificate.new(File.read(@@ca_file)) if defined? @@ca_file

      if defined?(@@pfx_file) and defined?(@@pfx_file_password)
        @@pkcs12 = OpenSSL::PKCS12.new( File.read(@@pfx_file), @@pfx_file_password )
      end
    end

    def fen2yuan(amount)
      value = amount.to_s
      [ value[0..-3], value[-2..-1] ].join('.').to_f
    end

    def yuan2fen(amount)
      value = amount.to_s.split('.')
      return (value.first + "00").to_i if value.size == 1

      a, b = value.first, value.last
      (b += "0") if b.size == 1
      (a + b[0..1]).to_i
    end

  end
end
