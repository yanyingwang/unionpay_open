module UnionpayOpen
  class Wap < Base
    class << self

      @@path = 'frontTransReq.do'
      def front_trans_req(**params)
        path =  __method__.to_s.camelize(:lower) + '.do'

        params.merge!(fixed_params)
        metadata = params.sort.map{ |k, v| "#{k}=#{v}" }.join('&')
        params[:signature] = sign(metadata)

        response = faraday.post(path, params)
        response.body
      end

    end
  end
end
