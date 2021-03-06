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
        
        def self.orderbook(pair)
          @params[:pair] = pair
          @method = "orderbook"
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
        
        def self.cancel_order(id)
          @method = 'cancel_order'
          @params[:id] = id
          doRequest
        end
        
        def self.list_deposits(limit=25)
          @method = 'list_deposits'
          @params[:limit] = limit
          doRequest
        end
        
        def self.list_withdrawals(limit=25)
          @method = 'list_withdrawals'
          @params[:limit] = limit
          doRequest
        end
        
        def self.list_history(limit=25,pair="LTC/BTC")
          @method = 'list_history'
          @params[:limit] = limit
          @params[:pair] = pair
          doRequest
        end
        
        def self.get_pairs
          @method = 'list_pairs'
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
            url = URI.parse("https://www.cptcambio.com/api/#{@method}/")
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
