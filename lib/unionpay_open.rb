require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/inflector'
require 'openssl'
require 'base64'
require 'faraday'

require "unionpay_open/version"
require "unionpay_open/base"
require "unionpay_open/wap"



module UnionpayOpen
  cattr_accessor :pfx_file,
                 :pfx_file_password,
                 :ca_file,
                 :merchant_no,
                 :pkcs12,
                 :x509_certificate,
                 :env,
                 :endpoint

  ENDPOINT_DEV = 'https://101.231.204.80:5000/gateway/api/'
  ENDPOINT_PRO = 'https://gateway.95516.com/gateway/api/'

  @@env = ENV['RACK_ENV']; @@env ||= 'development'
  @@endpoint = ( @@env == "production" ? ENDPOINT_PRO : ENDPOINT_DEV )

  extend self

  def config
    yield(self) if block_given?

    @@endpoint = ENDPOINT_PRO if @@env == "production"
    @@x509_certificate = OpenSSL::X509::Certificate.new(File.read(@@ca_file)) if @@ca_file

    if @@pfx_file and @@pfx_file_password
      @@pkcs12 = OpenSSL::PKCS12.new( File.read(@@pfx_file), @@pfx_file_password )
    end
  end

  def fen2yuan(amount)  # 10fen = 0.1yuan; 100fen = 1.0yuan
    value = "00" + amount.to_s
    [ value[0..-3], value[-2..-1] ].join('.').to_f
  end

  def yuan2fen(amount)  # 100yuan = 10000fen
    value = amount.to_s.split('.')

    return (value.first + "00").to_i if value.size == 1

    a, b = value.first, value.last
    (b += "0") if b.size == 1
    (a + b[0..1]).to_i
  end

end
