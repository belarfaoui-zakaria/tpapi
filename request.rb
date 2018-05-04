module Travelport
    class Request

        def initialize type = :http
          @headers = {}
          @type = type
          @api = "https://emea.universal-api.pp.travelport.com/B2BGateway/connect/uAPI/"
          if @type == :http
            header "Content-Type",  "text/xml;charset=UTF-8"
            header "Accept", "gzip,deflate"
            header "Cache-Control", "no-cache"
            header "Pragma", "no-cache"
            header "SOAPAction", '""'
          elsif @type == :file

          end
        end

        def set_type type
          @type = type
        end

        def header key, value
          @headers[key] = value
        end

        def run


          if @type == :file
            file = File.open(@path, "r")
            @result = file.read
            file.close
          elsif @type == :http

              # header "Authorization", "Basic #{@credentials}"
              header "Content-length", @request_body.length.to_s

              uri = URI(@request_url)
              http = Net::HTTP.new(uri.host, 443)
              req = Net::HTTP::Post.new(uri.request_uri, initheader = @headers)
              req.body = @request_body
              puts @request_body
              req.basic_auth @username, @password
              http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
              before_run
              # res = http.post(uri.request_uri, @request_body, @headers)
              res = http.request(req)
              @result = res.body
              puts @result
              return @result.tap do |content|
                after_run content
              end
          end

        end

        def before_run

        end

        def after_run content

        end

    end
end
