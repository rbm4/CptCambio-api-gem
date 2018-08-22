require "CptCambioApiWrapper/version"
require 'openssl'
require 'net/http'
require 'json'
require 'base64'

module CptCambioApiWrapper
    
    public
        def self.init(key,secret)
          @key = key
          @secret = secret
          @params = Hash.new
          return self
        end
        
        def self.instant_buy_price(currency1,currency2,buy)
          if buy == "buy"
              @params[:tipo] = "buy"
          else
              @params[:tipo] = "sell"
          end
          @params[:coin1] = currency1
          @params[:coin2] = currency2
          @method = "instant_buy_price"
          doRequest
        end
        
        def self.userInfo
          @method = 'userInfo'
          doRequest
        end
        
        def self.list_orders(limit=nil)
          if limit != nil
            @params[:limit] = limit
          end
          @method = 'list_orders'
          doRequest
        end
        
        def self.send_order(pair,amount,price,type)
          @method = 'send_order'
          @params[:currency_base] = pair.upcase
          @params[:amount] = amount.tr(",",".")
          @params[:price] = price.tr(",",".")
          @params[:type] = type
          doRequest
        end
        
        def self.cancel_order
          @method = 'cancel_order'
          doRequest
        end
        
        def self.list_deposits
          @method = 'list_deposits'
          doRequest
        end
        
        def self.list_withdrawals
          @method = 'list_withdrawals'
          doRequest
        end
        
        def self.list_history
          @method = 'list_history'
          doRequest
        end
        
    private
        def self.doRequest
            key = @key
            secret = @secret
            
            cipher = OpenSSL::Cipher.new('AES-128-CBC')
            cipher.encrypt # We are encypting
            # The OpenSSL library will generate random keys and IVs
            cipher.key = Base64.strict_decode64(secret)
            cipher.iv = Base64.strict_decode64(key)
            headers = {
                        "key" => key,
                        "secret" => secret,
            }
            url = URI.parse("https://cpt-cambio-new-rbm4.c9users.io/api/#{@method}/")
            req = Net::HTTP::Post.new(url.request_uri, initheader = headers)
            message = cipher.update(@params.to_json) + cipher.final
            
            params = Hash.new
            params[:digest] = Base64.strict_encode64(message)
            req.set_form_data(params)
            
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = (url.scheme == "https")
            response = http.request(req)
            begin
                JSON.parse(response.body)
            rescue
                response.body
            end
        end
end
