require 'test_helper'

class MainTest < Test::Unit::TestCase
  include Rack::Test::Methods

  MAGIC_HEADER_NAME = "SEQUENCESCAPE_LOGIN"
  COOKIE_NAME = "MyCookie"

  def app
    settings = {
      "magic_header_name" => MAGIC_HEADER_NAME,
      "cookie_name" => COOKIE_NAME,
      "validation_url" => "https://sso.example.com/validation",
      "user_agent" => "Ruby/prodsoft-code",
      "sso_redirect_url_prefix" => "https://sso.example.com/login?destination=",
      "error_text" => "Service unavailable"
    }
    Sanger::Rack::Authentication::SSO.new(lambda { |env| [200, {}, ["OK"]] }, settings)
  end

  def test_should_authenticate_if_cookie_passed_in
    Sanger::Rack::Authentication::SSO.any_instance.\
      expects(:sso_login_from_cookie).returns("ab3")
    get "/", {}, {"HTTP_COOKIE" => "#{COOKIE_NAME}=12345"}
    assert_equal 200, last_response.status
  end

  def test_should_not_authenticate_if_login_not_returned
    Sanger::Rack::Authentication::SSO.any_instance.\
      expects(:sso_login_from_cookie).returns("*")
    get "/", {}, {"HTTP_COOKIE" => "#{COOKIE_NAME}=12345"}
    assert_equal 200, last_response.status
  end

  def test_should_not_authenticate_if_network_error
    ::OpenURI.expects(:open_uri).raises(::OpenURI::HTTPError.new("Network error", nil))
    get "/", {}, {"HTTP_COOKIE" => "#{COOKIE_NAME}=12345"}
    assert_equal 503, last_response.status
  end

  def test_should_redirect_if_no_headers
    get "/", {}, {}
    assert_equal 302, last_response.status
    assert last_response.headers.include?("Location")
  end
  
  def test_should_clear_passed_login_header
    get "/", {}, {MAGIC_HEADER_NAME => "sneak"}
    assert_equal 302, last_response.status
  end
end
