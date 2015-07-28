module UnionpayOpen
  class Wap < Base
    class << self
      @@wap_fixed_params = { signMethod: '01',
                             txnType: '01',
                             txnSubType: '01',
                             bizType: '000201',
                             channelType: '08',
                             accessType: "0",
                             currencyCode: "156" }

      def front_trans_req(**params)
        path =  __method__.to_s.camelize(:lower) + '.do'

        camelized_params = params.map{ |k, v| [k.to_s.camelize(:lower).to_sym, v]}.to_h
        wap_params = global_fixed_params.merge(@@wap_fixed_params).merge(camelized_params)

        metadata = wap_params.sort.map{ |k, v| "#{k}=#{v}" }.join('&')
        wap_params[:signature] = sign(metadata)

        return wap_params if block_given?
        response = faraday.post(path, wap_params)
        response.body
      end

    end
  end
end
