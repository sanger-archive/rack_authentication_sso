require "cgi"
require "open-uri"
require "openssl"
require "ostruct"

module Sanger
  module Rack
    module Authentication
      class SSO
      
        def initialize(app, settings = {})
          @config = OpenStruct.new
          @config.magic_header_name = settings["magic_header_name"]
          @config.cookie_name = settings["cookie_name"]
          @config.validation_url = settings["validation_url"]
          @config.user_agent = settings["user_agent"]
          @config.sso_redirection_url = settings["sso_redirection_url"]
          @config.error_text = settings["error_text"]
          
          @app = app
        end
        
        def call(env)
          @request = ::Rack::Request.new(env)
          @request.env.delete(@config.magic_header_name)
          cookie_value = @request.cookies[@config.cookie_name]
          begin
            user = sso_login_from_cookie(cookie_value) unless cookie_value.nil?
            if user
              @request.env[@config.magic_header_name] = user
              @app.call(@request.env)
            else
              redirect_to_sso_server
            end
          rescue ::OpenURI::HTTPError
            error_text = @config.error_text.to_s
            [503, {"Content-Type" => "text/plain", "Content-Length" => error_text.length.to_s}, [error_text]]
          end
        end
        
        def sso_login_from_cookie(cookie_value)
          login = nil
          ::OpenURI.open_uri(@config.validation_url,
            "Cookie" => "#{@config.cookie_name}=#{cookie_value}",
            "User-Agent" => @config.user_agent) do |http|
            login = http.read.strip
          end
          if login == '*'
            return nil
          else
            return login
          end
        end
        
        def redirect_to_sso_server
          @response = ::Rack::Response.new
          destination = ::CGI::escape(@request.url)
          @response.redirect([@config.sso_redirection_url, destination].join)
          @response.finish
        end
      end
    end
  end
end
