module UnionpayOpen
  class Wap < Base
    class << self


      def method_missing(method, **params)
        wap_fixed_params = { signMethod: '01',
                             txnSubType: '00',
                             bizType: '000201',
                             channelType: '08',
                             accessType: "0",
                             currencyCode: "156" }

        case method
        when :front_trans_req
          wap_fixed_params[:txnType] = '01' # 01 消费类交易
          wap_fixed_params[:txnSubType] = '01'
        when :back_trans_req
          wap_fixed_params[:txnType] = '04' # 04 退货类交易
          wap_fixed_params[:txnSubType] = '00'
        end

        path =  method.to_s.camelize(:lower) + '.do'

        camelized_params = params.map{ |k, v| [k.to_s.camelize(:lower).to_sym, v]}.to_h

        wap_params = global_fixed_params.merge(wap_fixed_params).merge(camelized_params)

        metadata = wap_params.sort.map{ |k, v| "#{k}=#{v}" }.join('&')
        wap_params[:signature] = sign(metadata)

        return wap_params if block_given?

        response = faraday.post(path, wap_params)
        result = response.body

        if method == :back_trans_req
          result = result.split("&").map{ |r| r.split("=", 2) }.to_h
          resp_msg = result['respMsg'].force_encoding('utf-8')

          raise "#{response.env.url.to_s}   \n=> #{result['respMsg']}   \n=> #{result}" if resp_msg.match(/\[.*\]/).to_s != '[0000000]'

          result
        else
          result
        end

      end

    end
  end
end
